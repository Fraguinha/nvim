return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
  },
  keys = {
    { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
  },
  opts = {
    integrations = {
      diffview = true,
    },
    mappings = {
      popup = {
        ["p"] = "PushPopup",
        ["P"] = "PullPopup",
      },
    },
  },
}
