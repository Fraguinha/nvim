local events = require("neo-tree.events")
local command = require("neo-tree.command")

local function git_toggle_staged(state)
  local toplevel = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait().stdout:gsub("\n", "/")
  local staged_files = vim
    .system({ "git", "diff", "--cached", "--name-only" }, { text = true })
    :wait().stdout
    :gsub("\n", ";")
  local node = state.tree:get_node()
  local path = node:get_id():gsub(toplevel, "")
  if not staged_files:find(path) then
    vim.fn.system({ "git", "add", path })
  else
    vim.fn.system({ "git", "reset", "--", path })
  end
  events.fire_event(events.GIT_EVENT)
end

local enter_handler = function(_)
  vim.opt_local.signcolumn = "auto"
  vim.opt_local.foldcolumn = "0"
end
local open_handler = function(_)
  command.execute({ action = "close" })
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      position = "left",
      width = 80,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ["<tab><tab>"] = "close_window",
      },
    },
    filesystem = {
      scan_mode = "deep",
      group_empty_dirs = true,
      window = {
        mappings = {
          ["gg"] = { "git_commit_and_push", desc = "Git commit and push" },
          ["gp"] = { "git_push", desc = "Git push" },
          ["gs"] = { git_toggle_staged, desc = "Git stage toggle" },
          ["gc"] = { "git_commit", desc = "Git commit" },
          ["gr"] = { "git_revert_file", desc = "Git revert file" },
        },
      },
    },
    git_status = {
      window = {
        mappings = {
          ["gs"] = { git_toggle_staged, desc = "git_toggle_staged" },
        },
      },
    },
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = enter_handler,
      },
      {
        event = "file_opened",
        handler = open_handler,
      },
    },
  },
}
