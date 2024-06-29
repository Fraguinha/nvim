return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"letieu/harpoon-lualine",
	},
	opts = {
		options = {
			theme = "catppuccin",
			component_separators = "",
			section_separators = "",
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { "filename", "harpoon2" },
			lualine_x = { { "filetype", icons_enabled = false } },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
	},
}
