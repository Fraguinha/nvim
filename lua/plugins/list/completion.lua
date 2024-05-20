return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		{
			"hrsh7th/cmp-nvim-lsp",
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
			"petertriho/cmp-git",
			config = function()
				require("cmp_git").setup({
					filetypes = { "gitcommit", "NeogitCommitMessage" },
					gitlab = {
						hosts = { "gitlab.feedzai.com" },
					},
				})
			end,
		},
		{
			"L3MON4D3/LuaSnip",
			build = "make install_jsregexp",
			opts = {},
		},
		{
			"saadparwaiz1/cmp_luasnip",
		},
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		luasnip.config.set_config({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			enable_autosnippets = true,
		})

		cmp.setup.filetype({ "sql" }, {
			sources = {
				{ name = "vim-dadbod-completion" },
				{ name = "buffer", keyword_length = 5 },
			},
		})

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-u>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete({}),
				["<C-e>"] = cmp.mapping.abort(),
				["<C-y>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				["<C-n>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<C-p>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = {
				{ name = "nvim_lua" },
				{ name = "luasnip" },
				{ name = "nvim_lsp" },
				{ name = "git" },
				{ name = "path" },
				{ name = "buffer", keyword_length = 5 },
			},
			sorting = {
				comparators = {
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					cmp.config.compare.sort_text,
					cmp.config.compare.score,
					cmp.config.compare.recently_used,
					cmp.config.compare.kind,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
				priority_weight = 1,
			},
		})
	end,
}
