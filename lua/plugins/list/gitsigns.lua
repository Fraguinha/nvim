return {
	"lewis6991/gitsigns.nvim",
	config = function()
		local gitsigns = require("gitsigns")

		gitsigns.setup({
			numhl = true,
			current_line_blame = true,
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				vim.keymap.set("n", "[h", function()
					if vim.wo.diff then
						return "[h"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { buffer = bufnr })

				vim.keymap.set("n", "]h", function()
					if vim.wo.diff then
						return "]h"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { buffer = bufnr })

				vim.keymap.set("n", "<leader>gs", gs.stage_hunk)
				vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk)
				vim.keymap.set("n", "<leader>gr", gs.reset_hunk)
				vim.keymap.set("n", "<leader>gg", gs.preview_hunk)
				vim.keymap.set("n", "<leader>gd", gs.toggle_deleted)
				vim.keymap.set("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end)

				-- Text object
				vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
			end,
		})
	end,
}
