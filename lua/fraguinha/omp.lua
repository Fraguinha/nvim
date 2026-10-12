local M = {}

local state = { buf = nil, job = nil, root = nil, ready = false, pending = {}, tail = "" }

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "omp" })
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

local function relative(path, base)
  base = base or state.root or root()
  local full = vim.fn.fnamemodify(path, ":p")

  if base and full:sub(1, #base + 1) == base .. "/" then
    return full:sub(#base + 2)
  end

  return full
end

local function alive()
  return state.job ~= nil and vim.fn.jobwait({ state.job }, 0)[1] == -1
end

local function terminal_window()
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    return nil
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == state.buf then
      return win
    end
  end
end

local function ordinary_windows(tab)
  local count = 0
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      count = count + 1
    end
  end
  return count
end

local function can_close(win)
  return vim.api.nvim_win_get_config(win).relative ~= "" or ordinary_windows(vim.api.nvim_win_get_tabpage(win)) > 1
end

local function discard()
  local buf, job = state.buf, state.job
  state.buf, state.job, state.root = nil, nil, nil
  state.ready, state.pending, state.tail = false, {}, ""

  if job and vim.fn.jobwait({ job }, 0)[1] == -1 then
    vim.fn.jobstop(job)
  end

  if buf and vim.api.nvim_buf_is_valid(buf) then
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
      if vim.api.nvim_win_is_valid(win) and can_close(win) then
        vim.api.nvim_win_close(win, true)
      end
    end

    vim.api.nvim_buf_delete(buf, { force = true })
  end
end

local function deliver(text, submit)
  local payload = "\27[200~" .. text .. "\27[201~" .. (submit and "\r" or "")
  local ok, error = pcall(vim.api.nvim_chan_send, state.job, payload)

  if not ok then
    notify("could not send to OMP: " .. tostring(error), vim.log.levels.ERROR)
  end
end

local function flush()
  local pending = state.pending
  state.pending = {}

  for _, item in ipairs(pending) do
    if not alive() then
      return notify("OMP exited before context could be sent", vim.log.levels.ERROR)
    end

    deliver(item.text, item.submit)
  end
end

local function receive(job, data)
  if state.job ~= job or state.ready then
    return
  end

  local output = state.tail .. table.concat(data, "\n")

  if output:find("\27[?2004h", 1, true) then
    state.tail = ""
    vim.schedule(function()
      if state.job == job and alive() then
        state.ready = true
        flush()
      end
    end)
  else
    state.tail = output:sub(-7)
  end
end

local function start(cwd)
  if vim.fn.executable("omp") ~= 1 then
    return notify("omp executable is not available", vim.log.levels.ERROR)
  end

  if state.buf then
    discard()
  end

  local dir = cwd or root()
  vim.cmd("botright vnew")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local ok, job = pcall(vim.fn.jobstart, { "omp", "--cwd", dir }, {
    cwd = dir,
    term = true,
    on_stdout = receive,
    on_exit = function(id, code)
      vim.schedule(function()
        if state.job ~= id then
          return
        end

        state.job, state.ready, state.tail = nil, false, ""
        local unsent = #state.pending > 0
        state.pending = {}

        if unsent then
          notify("OMP exited with code " .. code .. " before context could be sent", vim.log.levels.ERROR)
        elseif code ~= 0 then
          notify("OMP exited with code " .. code, vim.log.levels.ERROR)
        end
      end)
    end,
  })

  if not ok or job <= 0 then
    vim.api.nvim_win_close(win, true)
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
    notify("could not start OMP: " .. (not ok and tostring(job) or "terminal job failed"), vim.log.levels.ERROR)
    return nil
  end

  state.buf, state.job, state.root = buf, job, dir
  state.ready, state.pending, state.tail = false, {}, ""
  vim.api.nvim_set_option_value("bufhidden", "hide", { buf = buf })
  return win
end

local function ensure(cwd)
  if alive() then
    local win = terminal_window()
    if win then
      return win
    end

    vim.cmd("botright vsplit")
    win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, state.buf)
    return win
  end

  return start(cwd)
end

function M.send(text, opts)
  local before = vim.api.nvim_get_current_win()
  if not ensure(opts and opts.cwd) then
    return
  end

  if vim.api.nvim_win_is_valid(before) then
    vim.api.nvim_set_current_win(before)
  end

  if state.ready then
    deliver(text, opts and opts.submit)
  else
    table.insert(state.pending, { text = text, submit = opts and opts.submit })
  end
end

local function mention_path(path, base)
  local name = relative(path, base)
  if name:find("[%s@\"']") then
    if not name:find('"', 1, true) then
      return '@"' .. name .. '"'
    elseif not name:find("'", 1, true) then
      return "@'" .. name .. "'"
    end
    notify("cannot mention path containing both quote types: " .. name, vim.log.levels.WARN)
    return nil
  end
  return "@" .. name
end

local function reference(path, from, to)
  local text = mention_path(path)
  if not text then
    return nil
  end

  if from and to and to > from then
    text = text .. " (lines " .. from .. "-" .. to .. ")"
  elseif from then
    text = text .. " (line " .. from .. ")"
  end

  return text
end

local function selection()
  local from = vim.fn.line("v")
  local to = vim.fn.line(".")

  if from > to then
    from, to = to, from
  end

  vim.cmd("normal! \27")

  return from, to
end

function M.mention(path, from, to)
  local text = reference(path, from, to)
  if text then
    M.send(text .. " ")
  end
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

  M.mention(path, selection())
end

function M.add_line()
  local path = vim.api.nvim_buf_get_name(0)

  if path == "" then
    return notify("buffer is not a file", vim.log.levels.WARN)
  end

  M.mention(path, vim.fn.line("."))
end

local function format_diagnostics(items)
  local parts = {}

  for _, item in ipairs(items) do
    local severity = vim.diagnostic.severity[item.severity] or "HINT"
    local message = item.message:gsub("%s+", " ")
    table.insert(parts, ("L%d %s: %s"):format(item.lnum + 1, severity:lower(), message))
  end

  return table.concat(parts, " | ")
end

function M.add_buffer_diagnostics()
  local path = vim.api.nvim_buf_get_name(0)

  if path == "" then
    return notify("buffer is not a file", vim.log.levels.WARN)
  end

  local items = vim.diagnostic.get(0)

  if #items == 0 then
    return notify("no diagnostics in buffer", vim.log.levels.WARN)
  end

  local ref = reference(path)
  if ref then
    M.send(ref .. " diagnostics: " .. format_diagnostics(items) .. " ")
  end
end

function M.add_selection_diagnostics()
  local path = vim.api.nvim_buf_get_name(0)

  if path == "" then
    return notify("buffer is not a file", vim.log.levels.WARN)
  end

  local from, to = selection()
  local items = {}

  for _, item in ipairs(vim.diagnostic.get(0)) do
    local first = item.lnum + 1
    local last = (item.end_lnum or item.lnum) + 1

    if first <= to and last >= from then
      table.insert(items, item)
    end
  end

  if #items == 0 then
    return notify("no diagnostics in selection", vim.log.levels.WARN)
  end

  local ref = reference(path, from, to)
  if ref then
    M.send(ref .. " diagnostics: " .. format_diagnostics(items) .. " ")
  end
end

function M.add_workspace_diagnostics()
  local grouped = {}
  local order = {}

  for _, item in ipairs(vim.diagnostic.get(nil)) do
    local path = vim.api.nvim_buf_is_valid(item.bufnr) and vim.api.nvim_buf_get_name(item.bufnr) or ""

    if path ~= "" then
      if not grouped[path] then
        grouped[path] = {}
        table.insert(order, path)
      end

      table.insert(grouped[path], item)
    end
  end

  if #order == 0 then
    return notify("no diagnostics in workspace", vim.log.levels.WARN)
  end

  local parts = {}

  for _, path in ipairs(order) do
    local ref = reference(path)
    if ref then
      table.insert(parts, ref .. " diagnostics: " .. format_diagnostics(grouped[path]))
    end
  end

  if #parts > 0 then
    M.send(table.concat(parts, " ") .. " ")
  end
end

local function picked_root(path, picker)
  local dir = vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path)
  local git = vim.fs.find(".git", { path = dir, upward = true })[1]
  if git then
    return vim.fs.dirname(git)
  end

  local cwd = picker:cwd()
  if type(cwd) == "string" and cwd ~= "" then
    cwd = vim.fs.normalize(vim.fn.fnamemodify(cwd, ":p"))
    if vim.fn.isdirectory(cwd) == 1 and (cwd == "/" or dir == cwd or dir:sub(1, #cwd + 1) == cwd .. "/") then
      return cwd
    end
  end
  return dir
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

  local cwd = picker:cwd()
  cwd = type(cwd) == "string" and cwd ~= "" and cwd or vim.uv.cwd()
  local paths = {}

  for _, item in ipairs(items) do
    local path = item and snacks.picker.util.path(item)
    if path then
      if path:sub(1, 1) ~= "/" and path:sub(1, 1) ~= "~" then
        path = cwd .. "/" .. path
      end
      path = vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
      if vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1 then
        table.insert(paths, path)
      end
    end
  end

  if #paths == 0 then
    return notify("no file in picker selection", vim.log.levels.WARN)
  end

  local selected_root = not alive() and picked_root(paths[1], picker) or nil
  local base = selected_root or state.root
  local mentions = {}

  for _, path in ipairs(paths) do
    local ref = mention_path(path, base)
    if ref then
      table.insert(mentions, ref)
    end
  end

  if #mentions > 0 then
    M.send(table.concat(mentions, " ") .. " ", { cwd = selected_root })
  end
end

function M.prompt()
  vim.ui.input({ prompt = "omp: " }, function(text)
    if not text or text == "" then
      return
    end

    M.send(text, { submit = true })
  end)
end

function M.prompt_selection()
  local path = vim.api.nvim_buf_get_name(0)

  if path == "" then
    return notify("buffer is not a file", vim.log.levels.WARN)
  end

  local from, to = selection()
  local ref = reference(path, from, to)
  if not ref then
    return
  end

  vim.ui.input({ prompt = "omp: " }, function(text)
    if not text or text == "" then
      return
    end

    M.send(ref .. " " .. text, { submit = true })
  end)
end

function M.navigate(direction)
  local keys = { left = "h", down = "j", up = "k", right = "l" }
  local key = keys[direction]

  if not key then
    return
  end

  vim.cmd("wincmd " .. key)

  if vim.api.nvim_get_current_buf() == state.buf then
    vim.cmd("startinsert")
  end
end

function M.focus()
  local win = ensure()
  if win then
    vim.api.nvim_set_current_win(win)
    vim.cmd("startinsert")
  end
end

function M.toggle()
  local win = terminal_window()

  if not win then
    return M.focus()
  end

  if can_close(win) then
    vim.api.nvim_win_close(win, true)
  else
    vim.api.nvim_set_current_win(win)
    vim.cmd("enew")
  end
end

function M.close()
  if not state.buf then
    return notify("OMP is not running", vim.log.levels.WARN)
  end

  discard()
end

return M
