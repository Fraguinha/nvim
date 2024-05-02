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
		vim.keymap.set("n", "<CR><CR>", telescope.extensions.projects.projects)

		-- Fuzzy find files
		vim.keymap.set("n", "<leader><leader>", function()
			builtin.find_files({ path_display = { "truncate" } })
		end)

		-- Fuzzy find
		vim.keymap.set("n", "<leader>ff", function()
			builtin.live_grep({ path_display = { "truncate" } })
		end)

		-- Fuzzy find in buffer
		vim.keymap.set("n", "<leader>fb", function()
			builtin.current_buffer_fuzzy_find({ previewer = false })
		end)

		-- Fuzzy find word
		vim.keymap.set("v", "<leader>fw", function()
			builtin.grep_string({ path_display = { "truncate" } })
		end)

		-- Resume last fuzzy search
		vim.keymap.set("n", "<leader>fr", builtin.resume)

		-- Help
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics)
		vim.keymap.set("n", "<leader>fh", builtin.help_tags)
		vim.keymap.set("n", "<leader>fk", builtin.keymaps)
		vim.keymap.set("n", "<leader>fm", builtin.man_pages)

		-- Neovim
		vim.keymap.set("n", "<leader>fn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end)

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
					require("telescope.themes").get_dropdown({}),
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
		telescope.load_extension("dap")
	end,
}
