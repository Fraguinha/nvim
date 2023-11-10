return {
	"ggandor/leap.nvim",
	dependencies = {
		{ "tpope/vim-repeat" },
	},
	config = function()
		local leap = require("leap")

		vim.api.nvim_set_hl(0, "LeapLabelPrimary", { fg = "red", bg = "none" })

		vim.keymap.set({ "x", "o" }, "x", function()
			leap.leap({ offset = -1, inclusive_op = true })
		end)

		vim.keymap.set({ "x", "o" }, "X", function()
			leap.leap({ offset = 2, backward = true })
		end)

		vim.keymap.set({ "n", "x", "o" }, "s", function()
			leap.leap({ target_windows = { vim.fn.win_getid() } })
		end)
	end,
}
