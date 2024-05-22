return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		local function collapse_directory_or_go_to_parent(state)
			local node = state.tree:get_node()
			if node.type == "directory" and node:is_expanded() then
				require("neo-tree.sources.filesystem").toggle_directory(state, node)
			else
				require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
			end
		end

		local function expand_directory_or_go_to_child_or_open_file(state)
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
			require("neo-tree.events").fire_event(require("neo-tree.events").GIT_EVENT)
		end

		require("neo-tree").setup({
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
