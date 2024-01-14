return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "nvim-telescope/telescope-frecency.nvim" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-telescope/telescope-dap.nvim" },
	},
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local frecency = telescope.extensions.frecency

		-- Fuzzy find files
		vim.keymap.set("n", "<leader><leader>", function()
			frecency.frecency({
				path_display = { "truncate" },
			})
		end)

		-- Projects
		vim.keymap.set("n", "<C-CR>", function()
			vim.cmd(":silent %bd!")
			telescope.extensions.projects.projects({})
		end)

		-- Fuzzy find buffers
		vim.keymap.set("n", "<C-b>", function()
			builtin.buffers({
				path_display = { "truncate" },
				sort_lastused = true,
				ignore_current_buffer = true,
			})
		end)

		-- Fuzzy find word
		vim.keymap.set("n", "<C-f>", function()
			builtin.live_grep({ path_display = { "truncate" } })
		end)
		vim.keymap.set("v", "<C-f>", function()
			builtin.grep_string({ path_display = { "truncate" } })
		end)

		-- Help
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics)
		vim.keymap.set("n", "<leader>fh", builtin.help_tags)
		vim.keymap.set("n", "<leader>fk", builtin.keymaps)
		vim.keymap.set("n", "<leader>fm", builtin.man_pages)

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
				frecency = {
					default_workspace = "CWD",
					ignore_patterns = { "*.git/*" },
				},
				ui_select = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("frecency")
		telescope.load_extension("ui-select")
		telescope.load_extension("dap")
	end,
}
