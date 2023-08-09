return {
    "elentok/format-on-save.nvim",
    config = function()
        local format_on_save = require("format-on-save")
        local formatters = require("format-on-save.formatters")
        format_on_save.setup({
            partial_update = true,
            formatter_by_ft = {
                c = formatters.lsp,
                -- java = formatters.lsp,
                ocaml = formatters.lsp,
                rust = formatters.lsp,
                python = formatters.lsp,
                javascript = formatters.lsp,
                typescript = formatters.lsp,
                javascriptreact = formatters.lsp,
                typescriptreact = formatters.lsp,
                html = formatters.lsp,
                css = formatters.lsp,
                json = formatters.lsp,
                yaml = formatters.lsp,
                lua = formatters.lsp,
                sh = formatters.shfmt,
            }
        })
    end,
}
