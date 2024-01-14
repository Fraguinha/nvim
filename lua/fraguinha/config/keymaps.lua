vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Copy to clipboard
vim.keymap.set("v", "<C-y>", '"+y')

-- Move lines respecting indentation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Disable keys
vim.keymap.set({ "n", "v" }, "<Return>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<Del>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<Bs>", "<Nop>")
vim.keymap.set({ "n", "v" }, "Q", "<Nop>")
vim.keymap.set({ "n", "v" }, "q:", "<Nop>")
