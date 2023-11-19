return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		local catppuccin = require("catppuccin")
		catppuccin.setup({
			flavour = "latte",
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
