local actions = require("snacks.picker.actions")

actions.select_only = function(picker)
  picker.list:select()
end

actions.git_stage = function(picker)
  local items = picker:selected({ fallback = true })
  for _, item in ipairs(items) do
    local toplevel = vim
      .system({ "git", "rev-parse", "--show-toplevel" }, { text = true })
      :wait().stdout
      :gsub("\n", "/")
    local staged_files = vim
      .system({ "git", "diff", "--cached", "--name-only" }, { text = true })
      :wait().stdout
      :gsub("\n", ";")
    local path = item.file:gsub(toplevel, "")
    if not staged_files:find(path) then
      vim.fn.system({ "git", "add", path })
    else
      vim.fn.system({ "git", "reset", "--", path })
    end
  end
end

actions.git_reset = function(picker)
  local items = picker:selected({ fallback = true })
  for _, item in ipairs(items) do
    local toplevel = vim
      .system({ "git", "rev-parse", "--show-toplevel" }, { text = true })
      :wait().stdout
      :gsub("\n", "/")
    local path = item.file:gsub(toplevel, "")
    vim.fn.system({ "git", "checkout", "--", path })
    vim.cmd("edit " .. path)
  end
end

return {
  "snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        header = false,
      },
      sections = {
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = { 2, 1 } },
        { icon = " ", title = "Recent Projects", section = "projects", indent = 2, padding = { 2, 1 } },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 2, 1 } },
        { section = "startup" },
      },
    },
    picker = {
      sources = {
        explorer = {
          win = {
            input = {
              keys = {
                ["gs"] = { "git_stage", mode = "n" },
                ["gr"] = { "git_reset", mode = "n" },
                ["<space>"] = { "select_only", mode = "n" },
                ["<tab><tab>"] = { "close", mode = "n" },
                ["<tab>"] = false,
                ["<s-tab>"] = false,
              },
            },
            list = {
              keys = {
                ["gs"] = { "git_stage", mode = "n" },
                ["gr"] = { "git_reset", mode = "n" },
                ["<space>"] = { "select_only", mode = "n" },
                ["<tab><tab>"] = { "close", mode = "n" },
                ["<tab>"] = false,
                ["<s-tab>"] = false,
              },
            },
          },
        },
      },
    },
  },
}
