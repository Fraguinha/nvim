On_attach = function(_, bufnr)
    local telescope = require("telescope.builtin")

    vim.keymap.set("n", "gd", telescope.lsp_definitions, { buffer = bufnr })
    vim.keymap.set("n", "gD", telescope.lsp_type_definitions, { buffer = bufnr })
    vim.keymap.set("n", "gR", telescope.lsp_references, { buffer = bufnr })
    vim.keymap.set("n", "gI", telescope.lsp_implementations, { buffer = bufnr })

    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr })

    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr })

    vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { buffer = bufnr })
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = bufnr })
    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr })
    vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { buffer = bufnr })
end

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            "williamboman/mason.nvim",
            opts = {},
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
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                {
                    "hrsh7th/cmp-nvim-lsp",
                    config = function()
                        Capabilities = vim.lsp.protocol.make_client_capabilities()
                        Capabilities = require("cmp_nvim_lsp").default_capabilities(Capabilities)
                    end,
                },
                {
                    "hrsh7th/cmp-nvim-lua",
                },
                {
                    "hrsh7th/cmp-path",
                },
                {
                    "hrsh7th/cmp-buffer",
                },
                {
                    "L3MON4D3/LuaSnip",
                    opts = {},
                },
                {
                    "saadparwaiz1/cmp_luasnip",
                },
            },
            config = function()
                local cmp = require("cmp")
                local luasnip = require("luasnip")

                luasnip.config.set_config {
                    history = true,
                    updateevents = "TextChanged,TextChangedI",
                    enable_autosnippets = true,
                }

                cmp.setup {
                    snippet = {
                        expand = function(args)
                            luasnip.lsp_expand(args.body)
                        end,
                    },
                    mapping = cmp.mapping.preset.insert {
                        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                        ["<C-u>"] = cmp.mapping.scroll_docs(4),
                        ["<C-Space>"] = cmp.mapping.complete {},
                        ["<C-e>"] = cmp.mapping.abort(),
                        ["<C-y>"] = cmp.mapping.confirm {
                            behavior = cmp.ConfirmBehavior.Replace,
                            select = true,
                        },
                        ["<Tab>"] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
                            elseif luasnip.expand_or_jumpable() then
                                luasnip.expand_or_jump()
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                        ["<S-Tab>"] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
                            elseif luasnip.jumpable(-1) then
                                luasnip.jump(-1)
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                    },
                    sources = {
                        { name = "nvim_lua" },
                        { name = "luasnip" },
                        { name = "nvim_lsp" },
                        { name = "path" },
                        { name = "buffer",  keyword_length = 5 },
                    },
                }
            end,
        },
        {
            "williamboman/mason-lspconfig.nvim",
            config = function()
                local servers = {
                    lua_ls = {
                        Lua = {
                            workspace = { checkThirdParty = false },
                            telemetry = { enable = false },
                        },
                    },
                    ocamllsp = {},
                    rust_analyzer = {},
                    clangd = {},
                    jdtls = {},
                    lemminx = {},
                    tsserver = {},
                    cssls = {},
                    jsonls = {},
                    jedi_language_server = {},
                    bashls = {},
                    dockerls = {},
                    docker_compose_language_service = {},
                }

                local mason_lspconfig = require("mason-lspconfig")

                mason_lspconfig.setup {
                    ensure_installed = vim.tbl_keys(servers),
                }

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
        },
    },
    config = function()
        local nvim_lspconfig = require("lspconfig")
    end,
}
