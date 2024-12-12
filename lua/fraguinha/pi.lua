---@class Fraguinha.Pi
local M = {}

local RATIO = "0.5"
local READY_TRIES = 60
local READY_DELAY = 250
local INPUT_DELAY = 200

local state = { pane = nil, root = nil }

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "pi" })
end

local function available()
  return vim.env.HERDR_ENV == "1" and vim.env.HERDR_PANE_ID ~= nil and vim.env.HERDR_SOCKET_PATH ~= nil
end

local function herdr(args, callback)
  local command = { "herdr" }
  vim.list_extend(command, args)

  vim.system(command, { text = true }, function(output)
    local result, error
    local stdout = vim.trim(output.stdout or "")
    local decoded_ok, decoded = pcall(vim.json.decode, stdout)

    if output.code ~= 0 then
      error = vim.trim(output.stderr or "") ~= "" and vim.trim(output.stderr) or "herdr exited with code " .. output.code
    elseif stdout == "" then
      result = {}
    elseif not decoded_ok or type(decoded) ~= "table" then
      error = "unexpected herdr response"
    elseif decoded.error then
      error = decoded.error.message or decoded.error.code
    else
      result = decoded.result or {}
    end

    vim.schedule(function()
      if callback then
        callback(result, error)
      end
    end)
  end)
end

local function root()
  local ok, dir = pcall(function()
    return LazyVim.root()
  end)

  if ok and type(dir) == "string" and dir ~= "" then
    return dir
  end

  return vim.uv.cwd()
end

local function relative(path)
  local base = state.root or root()
  local full = vim.fn.fnamemodify(path, ":p")

  if base and full:sub(1, #base + 1) == base .. "/" then
    return full:sub(#base + 2)
  end

  return full
end

local function alive(callback)
  if not state.pane then
    return callback(false)
  end

  herdr({ "pane", "get", state.pane }, function(result)
    callback(result ~= nil)
  end)
end

local function spawn(callback)
  state.root = root()

  local args = {
    "pane",
    "split",
    vim.env.HERDR_PANE_ID,
    "--direction",
    "right",
    "--ratio",
    RATIO,
    "--cwd",
    state.root,
    "--env",
    "SHELL_PANE=pi",
    "--no-focus",
  }

  herdr(args, function(result, error)
    local pane = result and result.pane and result.pane.pane_id

    if not pane then
      return notify("could not start pi: " .. (error or "unknown error"), vim.log.levels.ERROR)
    end

    state.pane = pane
    callback(pane, true)
  end)
end

local function ready(pane, started, callback, tries)
  if not started then
    return callback(pane)
  end

  tries = tries or READY_TRIES

  herdr({ "agent", "list" }, function(result)
    for _, agent in ipairs(result and result.agents or {}) do
      if agent.pane_id == pane then
        return callback(pane)
      end
    end

    if tries <= 1 then
      return notify("pi is not ready yet", vim.log.levels.WARN)
    end

    vim.defer_fn(function()
      ready(pane, started, callback, tries - 1)
    end, READY_DELAY)
  end)
end

local function discover(callback)
  herdr({ "agent", "list" }, function(result)
    for _, agent in ipairs(result and result.agents or {}) do
      if agent.agent == "pi" and agent.tab_id == vim.env.HERDR_TAB_ID and agent.pane_id ~= vim.env.HERDR_PANE_ID then
        return callback(agent.pane_id)
      end
    end

    callback(nil)
  end)
end

local function resolve(callback)
  alive(function(ok)
    if ok then
      return callback(state.pane)
    end

    discover(function(pane)
      state.pane = pane

      if pane then
        state.root = state.root or root()
      end

      callback(pane)
    end)
  end)
end

local function ensure(callback)
  if not available() then
    return notify("not running inside a herdr pane", vim.log.levels.ERROR)
  end

  resolve(function(pane)
    if pane then
      return callback(pane)
    end

    spawn(function(created, started)
      ready(created, started, function()
        callback(created)
      end)
    end)
  end)
end

local function unzoom(callback)
  herdr({ "pane", "zoom", "--pane", vim.env.HERDR_PANE_ID, "--off" }, function()
    if callback then
      callback()
    end
  end)
end

function M.send(text, opts)
  opts = opts or {}

  ensure(function(pane)
    herdr({ "pane", "send-text", pane, text }, function(_, error)
      if error then
        return notify(error, vim.log.levels.ERROR)
      end

      vim.defer_fn(function()
        herdr({ "pane", "send-keys", pane, "esc" }, function()
          if not opts.submit then
            return
          end

          herdr({ "pane", "send-keys", pane, "enter" }, function(_, submit_error)
            if submit_error then
              notify(submit_error, vim.log.levels.ERROR)
            end
          end)
        end)
      end, INPUT_DELAY)
    end)
  end)
end

function M.mention(path, from, to)
  local text = "@" .. relative(path)

  if from and to and to > from then
    text = text .. " (lines " .. from .. "-" .. to .. ")"
  elseif from then
    text = text .. " (line " .. from .. ")"
  end

  M.send(text .. " ")
end

function M.add_buffer()
  local path = vim.api.nvim_buf_get_name(0)

  if path == "" then
    return notify("buffer is not a file", vim.log.levels.WARN)
  end

  M.mention(path)
end

function M.add_selection()
  local path = vim.api.nvim_buf_get_name(0)

  if path == "" then
    return notify("buffer is not a file", vim.log.levels.WARN)
  end

  local from = vim.fn.line("v")
  local to = vim.fn.line(".")

  if from > to then
    from, to = to, from
  end

  vim.cmd("normal! \27")
  M.mention(path, from, to)
end

function M.add_line()
  local path = vim.api.nvim_buf_get_name(0)

  if path == "" then
    return notify("buffer is not a file", vim.log.levels.WARN)
  end

  M.mention(path, vim.fn.line("."))
end

function M.add_diagnostics()
  local path = vim.api.nvim_buf_get_name(0)

  if path == "" then
    return notify("buffer is not a file", vim.log.levels.WARN)
  end

  local items = vim.diagnostic.get(0)

  if #items == 0 then
    return notify("no diagnostics in buffer", vim.log.levels.WARN)
  end

  local parts = {}

  for _, item in ipairs(items) do
    local severity = vim.diagnostic.severity[item.severity] or "HINT"
    local message = item.message:gsub("%s+", " ")
    table.insert(parts, ("L%d %s: %s"):format(item.lnum + 1, severity:lower(), message))
  end

  M.send("@" .. relative(path) .. " diagnostics: " .. table.concat(parts, " | ") .. " ")
end

function M.add_picked()
  local ok, snacks = pcall(require, "snacks")

  if not ok then
    return notify("snacks picker is not available", vim.log.levels.ERROR)
  end

  local pickers = snacks.picker.get({ tab = true })

  if not pickers or #pickers == 0 then
    return notify("no active picker", vim.log.levels.WARN)
  end

  local picker = pickers[#pickers]
  local window = vim.api.nvim_get_current_win()

  for _, candidate in ipairs(pickers) do
    local list = candidate.list and candidate.list.win and candidate.list.win.win
    if list == window then
      picker = candidate
      break
    end
  end

  local selected_ok, items = pcall(function()
    return picker:selected({ fallback = true })
  end)

  if not selected_ok or type(items) ~= "table" then
    return notify("could not read picker selection", vim.log.levels.WARN)
  end

  local mentions = {}

  for _, item in ipairs(items) do
    local path = item and snacks.picker.util.path(item)
    if path and (vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1) then
      table.insert(mentions, "@" .. relative(path))
    end
  end

  if #mentions == 0 then
    return notify("no file in picker selection", vim.log.levels.WARN)
  end

  M.send(table.concat(mentions, " ") .. " ")
end

function M.prompt()
  vim.ui.input({ prompt = "pi: " }, function(text)
    if not text or text == "" then
      return
    end

    M.send(text, { submit = true })
  end)
end

function M.navigate(direction)
  local keys = { left = "h", down = "j", up = "k", right = "l" }
  local key = keys[direction]

  if not key then
    return
  end

  local before = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. key)

  if vim.api.nvim_get_current_win() ~= before or not available() then
    return
  end

  herdr({ "pane", "focus", "--pane", vim.env.HERDR_PANE_ID, "--direction", direction })
end

function M.focus()
  ensure(function()
    unzoom(function()
      herdr({ "pane", "focus", "--pane", vim.env.HERDR_PANE_ID, "--direction", "right" }, function(_, error)
        if error then
          notify(error, vim.log.levels.ERROR)
        end
      end)
    end)
  end)
end

function M.toggle()
  if not available() then
    return notify("not running inside a herdr pane", vim.log.levels.ERROR)
  end

  resolve(function(pane)
    if not pane then
      return M.focus()
    end

    herdr({ "pane", "zoom", "--pane", vim.env.HERDR_PANE_ID, "--toggle" }, function(_, error)
      if error then
        notify(error, vim.log.levels.ERROR)
      end
    end)
  end)
end

function M.close()
  if not available() then
    return notify("not running inside a herdr pane", vim.log.levels.ERROR)
  end

  resolve(function(pane)
    if not pane then
      return notify("pi is not running", vim.log.levels.WARN)
    end

    herdr({ "pane", "close", pane }, function(_, error)
      state.pane = nil

      if error then
        notify(error, vim.log.levels.ERROR)
      end
    end)
  end)
end

return M
