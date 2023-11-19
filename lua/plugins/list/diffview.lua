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

		local function review()
			if vim.bo.ft == "DiffviewFileHistory" then
				diffview.close()
			end
			if vim.bo.ft == "DiffviewFiles" then
				diffview.close()
			else
				diffview.open({ "origin/HEAD...HEAD" })
			end
		end

		local function review_commits()
			if vim.bo.ft == "DiffviewFiles" then
				diffview.close()
			end
			if vim.bo.ft == "DiffviewFileHistory" then
				diffview.close()
			else
				diffview.file_history(nil, { "--range=origin/HEAD...HEAD", "--right-only", "--no-merges" })
			end
		end

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

		vim.keymap.set({ "n" }, "<leader>gp", review)
		vim.keymap.set({ "n" }, "<leader>gm", review)

		vim.keymap.set({ "n" }, "<leader>gc", review_commits)

		vim.keymap.set({ "n" }, "<leader>gf", review_file)
	end,
}
