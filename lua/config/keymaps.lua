-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- File explorer
vim.keymap.set("n", "<tab><tab>", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "snacks_picker_list" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  vim.cmd("lua Snacks.explorer()")
end, { desc = "Open explorer" })

-- terminal
-- local nav = require("Navigator")
-- vim.keymap.set({ "n", "i" }, "<C-h>", nav.left, { desc = "Navigate left" })
-- vim.keymap.set({ "n", "i" }, "<C-j>", nav.down, { desc = "Navigate down" })
-- vim.keymap.set({ "n", "i" }, "<C-k>", nav.up, { desc = "Navigate up" })
-- vim.keymap.set({ "n", "i" }, "<C-l>", nav.right, { desc = "Navigate right" })

-- Notes
-- vim.keymap.set("n", "<BS><BS>", function()
--   require("fraguinha.modules.notes").Notes()
-- end)

-- Debug
vim.keymap.set("n", "<leader>dd", function()
  require("fraguinha.modules.debug").Debug()
end, { desc = "Debug" })
