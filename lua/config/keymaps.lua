-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- terminal
local nav = require("Navigator")
vim.keymap.set({ "n", "i" }, "<C-S-h>", nav.left, { desc = "Navigate left" })
vim.keymap.set({ "n", "i" }, "<C-S-j>", nav.down, { desc = "Navigate down" })
vim.keymap.set({ "n", "i" }, "<C-S-k>", nav.up, { desc = "Navigate up" })
vim.keymap.set({ "n", "i" }, "<C-S-l>", nav.right, { desc = "Navigate right" })

-- Find Files
vim.keymap.set("n", "<tab><tab>", function()
  Snacks.picker.explorer()
end, { desc = "Find Files" })
