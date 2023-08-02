vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "Y", "y$")

vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>p", '"+p')
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("n", "<leader>c", '"_c')

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("i", "<Tab>", "<C-t>")
vim.keymap.set("i", "<S-Tab>", "<C-d>")

-- Center screen after movement
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Disable keys
vim.keymap.set({ "n", "v" }, "<Return>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<Del>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<Bs>", "<Nop>")
vim.keymap.set({ "n", "v" }, "Q", "<Nop>")
vim.keymap.set({ "n", "v" }, "q:", "<Nop>")
