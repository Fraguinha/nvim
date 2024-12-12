-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- terminal
local nav = require("Navigator")
vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-h>", nav.left, { desc = "Navigate left" })
vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-j>", nav.down, { desc = "Navigate down" })
vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-k>", nav.up, { desc = "Navigate up" })
vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-l>", nav.right, { desc = "Navigate right" })
vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-Left>", nav.left, { desc = "Navigate left" })
vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-Down>", nav.down, { desc = "Navigate down" })
vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-Up>", nav.up, { desc = "Navigate up" })
vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-Right>", nav.right, { desc = "Navigate right" })

-- Git blame
vim.keymap.set("n", "<leader>gB", function()
  require("gitsigns").blame()
end, { desc = "Git Blame" })

-- GitHub
vim.keymap.set("n", "<leader>go", Fraguinha.github.open_in_neovim, { desc = "Open GitHub link in Neovim" })
