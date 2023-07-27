-- Auto format
local ocaml_group = vim.api.nvim_create_augroup("ocaml_group", { clear = true })

-- Remove trailing whitespaces
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = ocaml_group,
    pattern = "*",
    command = "lua vim.lsp.buf.format()",
})
