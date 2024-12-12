-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto format
local format_group = vim.api.nvim_create_augroup("format_group", { clear = true })

-- No automatic comments
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = format_group,
  pattern = "*",
  command = "set formatoptions-=o",
})

-- Remove trailing whitespaces
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = format_group,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Remove tailing newlines
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = format_group,
  pattern = "*",
  command = [[%s/\(\n\)\+\%$//e]],
})
