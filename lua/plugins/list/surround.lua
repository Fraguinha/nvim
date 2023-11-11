return {
	"kylechui/nvim-surround",
	config = function()
		require("nvim-surround").setup({
			keymaps = {
				insert = false,
				insert_line = false,
				normal = "sa",
				normal_line = "sl",
				normal_cur = "ss",
				normal_cur_line = "SS",
				visual = "sa",
				visual_line = "sl",
				delete = "sd",
				change = "sc",
				change_line = "scl",
			},
		})
	end,
}
