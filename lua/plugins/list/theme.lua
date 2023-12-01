return {
	"catppuccin/nvim",
	name = "catppuccin",
	dependencies = {
		"f-person/auto-dark-mode.nvim",
		config = {
			update_interval = 50,
			set_dark_mode = function()
				vim.api.nvim_set_option("background", "dark")
				vim.cmd("colorscheme catppuccin-mocha")
			end,
			set_light_mode = function()
				vim.api.nvim_set_option("background", "light")
				vim.cmd("colorscheme catppuccin-latte")
			end,
		},
	},
	priority = 1000,
	config = function()
		local catppuccin = require("catppuccin")
		catppuccin.setup({
			show_end_of_buffer = true,
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
				treesitter_context = true,
				nvimtree = true,
				gitsigns = true,
				neogit = true,
				fidget = true,
				mason = true,
				cmp = true,
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
