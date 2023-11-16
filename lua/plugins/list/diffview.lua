return {
	"sindrets/diffview.nvim",
	config = function()
		local diffview = require("diffview")

		vim.keymap.set({ "n", "v" }, "<C-s>", function()
			if vim.bo.ft == "DiffviewFileHistory" then
				diffview.close()
			else
				diffview.file_history(nil, { "%" })
			end
		end)
	end,
}
