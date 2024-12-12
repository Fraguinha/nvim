local function diff_against_base()
  local base = vim.fn.system("git rev-parse --abbrev-ref origin/HEAD 2>/dev/null"):gsub("%s+$", "")
  if vim.v.shell_error ~= 0 or base == "" then
    base = "origin/main"
  end
  vim.cmd("DiffviewOpen " .. base .. "...HEAD")
end

return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff View" },
    { "<leader>gm", diff_against_base, desc = "Diff Against Base Branch" },
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
