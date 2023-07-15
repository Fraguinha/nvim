return {
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

        cmp.event:on("menu_opened", function()
            vim.b.copilot_suggestion_hidden = true
        end)

        cmp.event:on("menu_closed", function()
            vim.b.copilot_suggestion_hidden = false
        end)
    end,
}
