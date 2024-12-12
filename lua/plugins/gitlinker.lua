return {
  "linrongbin16/gitlinker.nvim",
  cmd = "GitLink",
  keys = {
    { "<leader>gy", "<cmd>GitLink current_branch<cr>", desc = "Git Link (copy)", mode = { "n", "x" } },
    { "<leader>gb", "<cmd>GitLink! current_branch<cr>", desc = "Git Link (open)", mode = { "n", "x" } },
    { "<leader>gY", "<cmd>GitLink default_branch<cr>", desc = "Git Link Default (copy)", mode = { "n", "x" } },
    { "<leader>gB", "<cmd>GitLink! default_branch<cr>", desc = "Git Link Default (open)", mode = { "n", "x" } },
  },
  opts = {
    router = {
      browse = {
        ["^gitlab%.feedzai%.com"] = "https://gitlab.feedzai.com/"
          .. "{_A.ORG}/"
          .. "{_A.REPO}/blob/"
          .. "{_A.REV}/"
          .. "{_A.FILE}"
          .. "#L{_A.LSTART}"
          .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
      },
      blame = {
        ["^gitlab%.feedzai%.com"] = "https://gitlab.feedzai.com/"
          .. "{_A.ORG}/"
          .. "{_A.REPO}/blame/"
          .. "{_A.REV}/"
          .. "{_A.FILE}"
          .. "#L{_A.LSTART}"
          .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
      },
      default_branch = {
        ["^gitlab%.feedzai%.com"] = "https://gitlab.feedzai.com/"
          .. "{_A.ORG}/"
          .. "{_A.REPO}/blob/"
          .. "{_A.DEFAULT_BRANCH}/"
          .. "{_A.FILE}"
          .. "#L{_A.LSTART}"
          .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
      },
      current_branch = {
        ["^gitlab%.feedzai%.com"] = "https://gitlab.feedzai.com/"
          .. "{_A.ORG}/"
          .. "{_A.REPO}/blob/"
          .. "{_A.CURRENT_BRANCH}/"
          .. "{_A.FILE}"
          .. "#L{_A.LSTART}"
          .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
      },
    },
  },
}
