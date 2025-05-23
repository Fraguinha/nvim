return {
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      set_dark_mode = function()
        vim.cmd("colorscheme catppuccin-mocha")
      end,
      set_light_mode = function()
        vim.cmd("colorscheme catppuccin-mocha")
      end,
      update_interval = 3000,
      fallback = "dark",
    },
  },
}
