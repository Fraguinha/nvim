return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		local tree = require("neo-tree")
		local command = require("neo-tree.command")

		tree.setup({
			close_if_last_window = true,
			use_default_mappings = false,
			window = {
				position = "left",
				width = 80,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					["<Tab><Tab>"] = "close_window",
					["<space>"] = "open",
					["<esc>"] = "cancel",
					["<cr>"] = "open",
					["a"] = {
						"add",
						config = {
							show_path = "none",
						},
					},
					["A"] = "add_directory",
					["d"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["c"] = "copy",
					["m"] = "move",
					["i"] = "show_file_details",
				},
			},
			filesystem = {
				window = {
					mappings = {
						["."] = "toggle_hidden",
						["/"] = "fuzzy_finder",
						["[c"] = "prev_git_modified",
						["]c"] = "next_git_modified",
						["gu"] = "git_unstage_file",
						["ga"] = "git_add_file",
						["gr"] = "git_revert_file",
					},
					fuzzy_finder_mappings = {
						["<C-n>"] = "move_cursor_down",
						["<C-p>"] = "move_cursor_up",
					},
				},
				commands = {},
			},
			event_handlers = {
				{
					event = "file_opened",
					handler = function()
						command.execute({ action = "close" })
					end,
				},
			},
		})

		vim.keymap.set("n", "<Tab><Tab>", function()
			command.execute({ "toggle" })
		end)
	end,
}
