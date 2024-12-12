-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- File explorer
vim.keymap.set("n", "<tab><tab>", function()
  require("neo-tree.command").execute({ action = "focus", reveal = true })
end, { desc = "Open explorer" })

-- terminal
local nav = require("Navigator")
vim.keymap.set({ "n", "i" }, "<C-h>", nav.left, { desc = "Navigate left" })
vim.keymap.set({ "n", "i" }, "<C-j>", nav.down, { desc = "Navigate down" })
vim.keymap.set({ "n", "i" }, "<C-k>", nav.up, { desc = "Navigate up" })
vim.keymap.set({ "n", "i" }, "<C-l>", nav.right, { desc = "Navigate right" })

-- Notes
vim.keymap.set("n", "<BS><BS>", function()
  local notes_dir = vim.fn.expand(vim.g.notes_dir)
  local in_notes = vim.fn.expand("%:p"):find(notes_dir)

  if not in_notes then
    vim.g._notes_previous_file = vim.fn.expand("%:p")
    vim.cmd("e " .. notes_dir .. vim.g.notes_root)
  else
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local path = vim.api.nvim_buf_get_name(buf)
      if path:find(notes_dir) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
    vim.cmd("e " .. vim.g._notes_previous_file)
  end
end)

-- Debug
vim.keymap.set("n", "<leader>dd", function()
  local dap = require("dap")

  local remote_config = function(filetype)
    local host_name = vim.fn.input("Debug hostname [default: 127.0.0.1]: ")
    local port = vim.fn.input("Debug port: ")

    if host_name == "" then
      host_name = "127.0.0.1"
    end

    local config = {
      name = "Debug (Attach) - Remote " .. port,
      type = filetype,
      request = "attach",
      hostName = host_name,
      port = port,
    }

    return config
  end

  local executable_config = function(filetype)
    local executable = vim.fn.input({ "Debug executable: ", vim.fn.getcwd() .. "/", "file" })

    local config = {
      type = "codelldb",
      request = "launch",
      program = executable,
      cwd = "${workspaceFolder}",
      terminal = "integrated",
      sourceLanguages = { filetype },
    }

    return config
  end

  local filetype = vim.bo.filetype
  local mode = vim.fn.input("Debug mode [remote|executable]: ")

  local config = {}
  if mode == "" or string.find("remote", mode) then
    config = remote_config(filetype)
  elseif string.find("executable", mode) then
    config = executable_config(filetype)
  end

  if not dap.configurations[filetype] then
    dap.configurations[filetype] = {}
    table.insert(dap.configurations[filetype], config)
  end

  dap.run(config)
end, { desc = "Debug" })
