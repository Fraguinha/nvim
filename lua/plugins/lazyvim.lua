return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "default",
    },
  },
  {
    "folke/flash.nvim",
    enabled = false,
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>sf",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>sF",
        function()
          Snacks.picker.files({ cwd = vim.uv.cwd() })
        end,
        desc = "Find Files (cwd)",
      },
      {
        "<leader>sP",
        function()
          Snacks.picker.lazy()
        end,
        desc = "Search Plugin Spec",
      },
    },
  },
}
