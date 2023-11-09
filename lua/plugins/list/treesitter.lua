return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {},
			sync_install = true,
			auto_install = true,
			ignore_install = {},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "markdown" },
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
					},
					selection_modes = {
						["@function.outer"] = "V",
						["@class.outer"] = "V",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]a"] = "@parameter.outer",
						["]f"] = "@function.outer",
					},
					goto_next_end = {
						["]A"] = "@parameter.outer",
						["]F"] = "@function.outer",
					},
					goto_previous_start = {
						["[a"] = "@parameter.outer",
						["[f"] = "@function.outer",
					},
					goto_previous_end = {
						["[A"] = "@parameter.outer",
						["[F"] = "@function.outer",
					},
					goto_next = {},
					goto_previous = {},
				},
			},
		})
	end,
}
