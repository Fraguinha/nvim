return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local oil = require("oil")

		oil.setup({
			default_file_explorer = true,
			columns = {
				"icon",
				"permissions",
				"size",
				"mtime",
			},
			keymaps = {
				["-"] = "actions.parent",
				["<BS>"] = "actions.close",
				["<CR>"] = "actions.select",
				["gs"] = "actions.change_sort",
				["gx"] = "actions.open_external",
				["g."] = "actions.toggle_hidden",
			},
			use_default_keymaps = false,
		})

		vim.keymap.set("n", "-", oil.open)
	end,
}
