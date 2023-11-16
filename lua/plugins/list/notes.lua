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

		vim.keymap.set("n", "<C-Tab>", function()
			vim.cmd("NvimTreeClose")
			if vim.bo.ft == "norg" and vim.fn.expand("%:t") == "index.norg" then
				vim.cmd("Neorg return")
			else
				vim.cmd("Neorg index")
			end
		end)
	end,
}
