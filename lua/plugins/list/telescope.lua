return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-telescope/telescope-dap.nvim" },
	},
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		-- Projects
		vim.keymap.set("n", "sp", function()
			vim.cmd("bufdo bd")
			telescope.extensions.projects.projects()
		end)

		-- Fuzzy find files
		vim.keymap.set("n", "sf", function()
			builtin.find_files({ path_display = { "truncate" } })
		end)

		-- Fuzzy find
		vim.keymap.set("n", "sg", function()
			builtin.live_grep({ path_display = { "truncate" } })
		end)
		-- Fuzzy find word
		vim.keymap.set("v", "sg", function()
			builtin.grep_string({ path_display = { "truncate" } })
		end)

		-- Fuzzy find word
		vim.keymap.set("n", "sb", function()
			builtin.current_buffer_fuzzy_find({ path_display = { "truncate" } })
		end)

		-- Help
		vim.keymap.set("n", "sd", builtin.diagnostics)
		vim.keymap.set("n", "sh", builtin.help_tags)
		vim.keymap.set("n", "sk", builtin.keymaps)

		telescope.setup({
			defaults = {
				layout_strategy = "vertical",
				layout_config = {
					width = 0.99,
					height = 0.99,
				},
			},
			pickers = {
				git_commits = {
					layout_strategy = "vertical",
				},
				git_bcommits = {
					layout_strategy = "vertical",
				},
				git_status = {
					layout_strategy = "vertical",
				},
			},
			extensions = {
				ui_select = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
		telescope.load_extension("dap")
	end,
}
