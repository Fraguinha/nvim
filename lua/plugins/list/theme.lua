return {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
        local catppuccin = require("catppuccin")
        catppuccin.setup {
            color_overrides = {
                mocha = {
                    mantle = "#1e1e2e",
                },
            },
            integrations = {
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                    },
                    inlay_hints = {
                        background = true,
                    },
                },
                dap = {
                    enabled = true,
                    enable_ui = true,
                },
                telescope = {
                    enabled = true,
                    style = "classic",
                },
                treesitter = true,
                nvimtree = true,
                gitsigns = true,
                neogit = true,
                mason = true,
                cmp = true,
            },
        }
        vim.cmd.colorscheme "catppuccin-mocha"
    end,
}
