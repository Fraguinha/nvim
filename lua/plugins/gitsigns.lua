---@type LazySpec
return {
  "lewis6991/gitsigns.nvim",
  commit = "b8cf5e8efaa0036d493a2e2dfed768c3a03fac73",
  opts = function(_, opts)
    local get_icon = require("astroui").get_icon
    opts.signs_staged = {
      add = { text = get_icon "GitSign" },
      change = { text = get_icon "GitSign" },
      delete = { text = get_icon "GitSign" },
      topdelete = { text = get_icon "GitSign" },
      changedelete = { text = get_icon "GitSign" },
      untracked = { text = get_icon "GitSign" },
    }
    opts.numhl = true
    opts.current_line_blame = true
    opts.signs_staged_enable = true
  end,
}
