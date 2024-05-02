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
			perspective = {
				priority = "root",
				root_tell = "index.md",
			},
		})

		local function toggle_notes()
			local project = require("project_nvim.project")
			local notes_dir = "~/notes/"

			vim.cmd("Neotree close")

			local in_notes = vim.fn.expand("%:~"):find(notes_dir)
			if not in_notes then
				vim.g.last_project_root = project.get_project_root()
				vim.g.last_project_file = vim.fn.expand("%:.")

				project.set_pwd(notes_dir, "keymap")
				vim.cmd("e index.md")
			else
				project.set_pwd(vim.g.last_project_root, "keymap")
				vim.cmd("silent! %bd!")
				vim.cmd("silent! e " .. vim.g.last_project_file)
			end
		end

		vim.keymap.set("n", "<BS><BS>", toggle_notes)
	end,
}
