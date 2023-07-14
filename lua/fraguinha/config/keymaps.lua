vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "Y", "y$")

vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>p", '"+p')
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("n", "<leader>c", '"_c')

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Disable keys
vim.keymap.set({ "n", "v" }, "<Return>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<Del>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<Bs>", "<Nop>")
vim.keymap.set({ "n", "v" }, "Q", "<Nop>")
