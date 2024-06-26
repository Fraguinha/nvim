vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Copy to clipboard
vim.keymap.set("v", "<C-y>", '"+y')

-- Move lines respecting indentation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Disable keys
vim.keymap.set({ "n", "v", "x", "s" }, "<Return>", "<Nop>")
vim.keymap.set({ "n", "v", "x", "s" }, "<Space>", "<Nop>")
vim.keymap.set({ "n", "v", "x", "s" }, "<Del>", "<Nop>")
vim.keymap.set({ "n", "v", "x", "s" }, "<BS>", "<Nop>")
vim.keymap.set({ "n", "v", "x", "s" }, "Q", "<Nop>")
vim.keymap.set({ "n", "v", "x", "s" }, "s", "<Nop>")
vim.keymap.set({ "n", "v", "x", "s" }, "q:", "<Nop>")
