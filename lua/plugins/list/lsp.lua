On_attach = function(_, bufnr)
    local telescope = require("telescope.builtin")

    vim.keymap.set("n", "gd", telescope.lsp_definitions, { buffer = bufnr })
    vim.keymap.set("n", "gr", telescope.lsp_references, { buffer = bufnr })
    vim.keymap.set("n", "gi", telescope.lsp_implementations, { buffer = bufnr })
    vim.keymap.set("n", "go", telescope.lsp_type_definitions, { buffer = bufnr })

    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr })

    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr })

    vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { buffer = bufnr })
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = bufnr })
    vim.keymap.set("n", "<leader>lca", vim.lsp.buf.code_action, { buffer = bufnr })
    vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { buffer = bufnr })

    vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
            local opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                scope = 'cursor',
            }
            vim.diagnostic.open_float(nil, opts)
        end
    })
end

return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        {
            "williamboman/mason.nvim",
            opts = {},
        },
        {
            "neovim/nvim-lspconfig",
        },
        {
            "j-hui/fidget.nvim",
            opts = {},
            tag = "legacy",
        },
        {
            "folke/neodev.nvim",
            opts = {},
        },
    },
    config = function()
        local servers = {
            lua_ls = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                },
            },
            clangd = {},
            jdtls = {},
            ocamllsp = {
                extendedHover = {
                    enable = true,
                },
                codelens = {
                    enable = true,
                },
            },
            rust_analyzer = {},
            pylsp = {},
            tsserver = {},
            cssls = {},
            tailwindcss = {},
            lemminx = {},
            jsonls = {},
            yamlls = {},
            bashls = {},
            dockerls = {},
            docker_compose_language_service = {},
            texlab = {},
        }

        local mason_lspconfig = require("mason-lspconfig")

        mason_lspconfig.setup {
            ensure_installed = vim.tbl_keys(servers),
        }

        -- Setup diagnostics
        local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
            opts = opts or {}
            opts.border = opts.border or border
            return orig_util_open_floating_preview(contents, syntax, opts, ...)
        end

        mason_lspconfig.setup_handlers {
            function(server_name)
                if server_name == "jdtls" then
                    return
                end

                require("lspconfig")[server_name].setup {
                    capabilities = Capabilities,
                    on_attach = On_attach,
                    settings = servers[server_name],
                }
            end,
        }
    end,
}
