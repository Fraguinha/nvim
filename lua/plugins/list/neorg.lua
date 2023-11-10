return {
	"nvim-neorg/neorg",
	build = ":Neorg sync-parsers",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							notes = "~/notes",
						},
						default_workspace = "notes",
					},
				},
			},
		})

		vim.keymap.set("n", "<C-n>", function()
			if vim.bo.ft == "norg" and vim.fn.expand("%") == vim.fn.glob("~/notes/index.norg") then
				vim.cmd("Neorg return")
			else
				vim.cmd("Neorg index")
			end
		end)
	end,
}
