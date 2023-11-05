return {
	"kylechui/nvim-surround",
	config = function()
		require("nvim-surround").setup({
			keymaps = {
				normal = "gsa",
				normal_cur = "gss",
				normal_line = "gsl",
				normal_cur_line = "gSS",
				change = "gsc",
				delete = "gsd",
				visual = "gsa",
				visual_line = "gsl",
			},
		})
	end,
}
