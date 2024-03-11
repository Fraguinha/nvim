return {
	"kylechui/nvim-surround",
	opts = {
		keymaps = {
			insert = false,
			insert_line = false,
			normal = "ys",
			normal_line = "ysl",
			normal_cur = "yss",
			normal_cur_line = "ySS",
			visual = "ys",
			visual_line = "ysl",
			delete = "yds",
			change = "ycs",
			change_line = "ycsl",
		},
		aliases = {
			["b"] = { ")", "}", "]" },
			["q"] = { '"', "'", "`" },
		},
	},
}
