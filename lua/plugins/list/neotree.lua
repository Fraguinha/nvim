return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		local neotree = require("neo-tree")
		local filesystem = require("neo-tree.sources.filesystem")
		local renderer = require("neo-tree.ui.renderer")
		local common_commands = require("neo-tree.sources.common.commands")
		local events = require("neo-tree.events")
		local command = require("neo-tree.command")

		local function collapse_directory_or_go_to_parent(state)
			local node = state.tree:get_node()
			if node.type == "directory" and node:is_expanded() then
				filesystem.toggle_directory(state, node)
			else
				renderer.focus_node(state, node:get_parent_id())
			end
		end

		local function expand_directory_or_go_to_child_or_open_file(state)
			local node = state.tree:get_node()
			if node.type == "directory" then
				if not node:is_expanded() then
					filesystem.toggle_directory(state, node)
				elseif node:has_children() then
					renderer.focus_node(state, node:get_child_ids()[1])
				end
			end
			if node.type == "file" then
				common_commands.open(state, function() end)
			end
		end

		local function git_toggle_staged(state)
			local toplevel = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true })
				:wait().stdout
				:gsub("\n", "/")
			local staged_files = vim.system({ "git", "diff", "--cached", "--name-only" }, { text = true })
				:wait().stdout
				:gsub("\n", ";")
			local node = state.tree:get_node()
			local path = node:get_id():gsub(toplevel, "")
			if not staged_files:find(path) then
				vim.fn.system({ "git", "add", path })
			else
				vim.fn.system({ "git", "reset", "--", path })
			end
			events.fire_event(events.GIT_EVENT)
		end

		neotree.setup({
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
					["h"] = collapse_directory_or_go_to_parent,
					["l"] = expand_directory_or_go_to_child_or_open_file,
				},
			},
			filesystem = {
				window = {
					mappings = {
						["."] = "toggle_hidden",
						["/"] = "fuzzy_finder",
						["[c"] = "prev_git_modified",
						["]c"] = "next_git_modified",
						["gs"] = git_toggle_staged,
						["gu"] = "git_revert_file",
					},
					fuzzy_finder_mappings = {
						["<C-n>"] = "move_cursor_down",
						["<C-p>"] = "move_cursor_up",
					},
				},
				scan_mode = "deep",
				group_empty_dirs = true,
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
			command.execute({ action = "focus", reveal = true })
		end)
	end,
}
