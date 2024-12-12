return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff View" },
    { "<leader>gf", "<cmd>DiffviewFileHistory<cr>", desc = "Repo History" },
    { "<leader>gF", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
  },
  opts = {
    keymaps = {
      view = {
        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
      },
      file_panel = {
        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
      },
      file_history_panel = {
        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
      },
    },
  },
}
