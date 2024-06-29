return {
	"ggandor/leap.nvim",
	dependencies = {
		{ "tpope/vim-repeat" },
	},
	config = function()
		local leap = require("leap")

		leap.opts.safe_labels = {}

		vim.api.nvim_set_hl(0, "LeapLabelPrimary", { fg = "magenta", bg = "none" })

		vim.keymap.set("n", "ss", function()
			leap.leap({ target_windows = { vim.fn.win_getid() } })
		end)

		vim.keymap.set({ "x", "o" }, "s", function()
			leap.leap({ offset = -1, inclusive_op = true })
		end)

		vim.keymap.set({ "x", "o" }, "S", function()
			leap.leap({ backward = true, inclusive_op = true })
		end)

		vim.keymap.set({ "x", "o" }, "X", function()
			leap.leap({ offset = 2, backward = true, inclusive_op = true })
		end)

		vim.keymap.set({ "x", "o" }, "x", function()
			leap.leap({ offset = 1, inclusive_op = true })
		end)
	end,
}
