return {
	"jakewvincent/mkdnflow.nvim",
	config = function()
		require("mkdnflow").setup({
			links = {
				transform_explicit = function(text)
					text = text:gsub(" ", "-")
					text = text:lower()
					return text
				end,
			},
		})

		local project = require("project_nvim.project")
		vim.keymap.set("n", "<C-Tab>", function()
			vim.cmd("NvimTreeClose")
			if vim.bo.ft == "markdown" then
				project.set_pwd(vim.g.last_project_root, "keymap")
				vim.cmd("silent! %bd!")
				vim.cmd("silent! e " .. vim.g.last_project_file)
			else
				vim.g.last_project_root = project.get_project_root()
				vim.g.last_project_file = vim.fn.expand("%:.")
				project.set_pwd("~/notes/", "keymap")
				vim.cmd("e index.md")
			end
		end)
	end,
}
