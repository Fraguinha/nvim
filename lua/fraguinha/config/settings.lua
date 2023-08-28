vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.wo.signcolumn = "yes"

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.mouse = nil
vim.opt.mousescroll = "ver:0,hor:0"

vim.opt.cursorline = true

vim.opt.list = true
vim.opt.showbreak = "↪"
vim.opt.listchars = {
    tab = "→ ",
    eol = "↩",
    extends = "…",
}

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.laststatus = 3

vim.opt.showmode = false

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 8

vim.opt.completeopt = "menuone,noselect"

vim.opt.termguicolors = true
