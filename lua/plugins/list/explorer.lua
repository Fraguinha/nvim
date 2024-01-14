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

		tree.setup({
			close_if_last_window = true,
			use_default_mappings = false,
			window = {
				position = "current",
				width = 80,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					["<Tab><Tab>"] = "close_window",
					["<esc>"] = "cancel",
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
					["h"] = function(state)
						local node = state.tree:get_node()
						if node.type == "directory" and node:is_expanded() then
							require("neo-tree.sources.filesystem").toggle_directory(state, node)
						else
							require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
						end
					end,
					["l"] = function(state)
						local node = state.tree:get_node()

						if node.type == "directory" then
							if not node:is_expanded() then
								require("neo-tree.sources.filesystem").toggle_directory(state, node)
							elseif node:has_children() then
								require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
							end
						end

						if node.type == "file" then
							require("neo-tree.sources.common.commands").open(state, function() end)
						end
					end,
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
			},
			event_handlers = {
				{
					event = "file_opened",
					handler = function()
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			},
		})

		vim.keymap.set("n", "<Tab><Tab>", function()
			require("neo-tree.command").execute({ action = "focus", reveal = true })
		end)
	end,
}
