return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local api = require("nvim-tree.api")

		vim.keymap.set("n", "<Esc><Esc>", function()
			api.tree.toggle()
		end)

		local function custom_open_edit()
			api.node.open.edit()
			if vim.bo.ft ~= "NvimTree" then
				api.tree.close()
			end
		end

		require("nvim-tree").setup({
			hijack_cursor = true,
			view = { width = 80 },
			filters = { custom = { "^.git$" } },
			sync_root_with_cwd = true,
			respect_buf_cwd = true,
			update_focused_file = {
				enable = true,
				update_root = true,
			},
			on_attach = function(bufnr)
				local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }

				vim.keymap.set("n", "<CR>", custom_open_edit, opts)

				vim.keymap.set("n", "h", api.node.navigate.parent_close, opts)
				vim.keymap.set("n", "l", custom_open_edit, opts)

				vim.keymap.set("n", "i", api.tree.toggle_gitignore_filter, opts)
				vim.keymap.set("n", ".", api.tree.toggle_hidden_filter, opts)

				vim.keymap.set("n", "a", api.fs.create, opts)
				vim.keymap.set("n", "r", api.fs.rename, opts)
				vim.keymap.set("n", "x", api.fs.cut, opts)
				vim.keymap.set("n", "d", api.fs.remove, opts)
				vim.keymap.set("n", "D", api.fs.trash, opts)
				vim.keymap.set("n", "p", api.fs.paste, opts)
				vim.keymap.set("n", "y", api.fs.copy.node, opts)
				vim.keymap.set("n", "c", api.fs.copy.filename, opts)
				vim.keymap.set("n", "C", api.fs.copy.relative_path, opts)
				vim.keymap.set("n", "gc", api.fs.copy.absolute_path, opts)

				vim.keymap.set("n", "f", api.live_filter.start, opts)
				vim.keymap.set("n", "F", api.live_filter.clear, opts)

				vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts)
				vim.keymap.set("n", "]c", api.node.navigate.git.next, opts)
				vim.keymap.set("n", "]d", api.node.navigate.diagnostics.next, opts)
				vim.keymap.set("n", "[d", api.node.navigate.diagnostics.prev, opts)
			end,
		})
	end,
}
