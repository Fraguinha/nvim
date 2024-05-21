return {
	"sindrets/diffview.nvim",
	config = function()
		local diffview = require("diffview")

		diffview.setup({
			file_panel = {
				win_config = {
					height = 16,
					position = "bottom",
				},
			},
			default_args = {
				DiffviewOpen = { "--imply-local" },
				DiffviewFileHistory = { "--imply-local" },
			},
		})

		local function review_file()
			if vim.bo.ft == "DiffviewFiles" then
				diffview.close()
			end
			if vim.bo.ft == "DiffviewFileHistory" then
				diffview.close()
			else
				diffview.file_history(nil, { "%" })
			end
		end

		vim.keymap.set({ "n" }, "gl", review_file)
	end,
}
