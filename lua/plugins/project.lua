return {
  "adamwojt/project.nvim", -- replace with "ahmedkhalf/project.nvim" when pulled
  branch = "adamwojt/issue_119/default_telescope_actions", -- remove when pulled
  config = function()
    require("project_nvim").setup({
      detection_methods = { "pattern" },
      patterns = { ".git" },
      telescope_default_action = "cd",
    })
  end,
}
