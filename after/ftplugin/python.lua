vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = Format_group,
    pattern = "*",
    callback = function(_)
        vim.lsp.buf.format()
    end,
})
