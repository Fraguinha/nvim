return {
	"lewis6991/gitsigns.nvim",
	opts = {
		numhl = true,
		current_line_blame = true,
		_signs_staged_enable = true,
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			vim.keymap.set("n", "[c", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end, { buffer = bufnr })

			vim.keymap.set("n", "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end, { buffer = bufnr })

			vim.keymap.set("n", "gs", gs.stage_hunk)
			vim.keymap.set("n", "gu", gs.reset_hunk)
			vim.keymap.set("n", "gh", gs.preview_hunk_inline)

			-- Text object
			vim.keymap.set({ "o", "x" }, "ic", ":<C-U>Gitsigns select_hunk<CR>")
		end,
	},
}
