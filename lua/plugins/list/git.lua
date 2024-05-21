return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"sindrets/diffview.nvim",
	},
	config = function()
		local neogit = require("neogit")

		neogit.setup({
			disable_signs = true,
			disable_hint = true,
			disable_commit_confirmation = true,
			disable_builtin_notifications = true,
			kind = "replace",
		})

		vim.keymap.set("n", "<leader><CR>", function()
			vim.cmd("Neotree close")
			if vim.bo.ft == "NeogitStatus" then
				vim.cmd.normal("q")
			else
				vim.cmd("Neogit")
			end
		end)
	end,
}
