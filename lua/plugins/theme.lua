return {
  "f-person/auto-dark-mode.nvim",
  config = {
    set_dark_mode = function()
      vim.api.nvim_set_option_value("background", "dark", {})
      vim.cmd("colorscheme catppuccin-mocha")
    end,
    set_light_mode = function()
      vim.api.nvim_set_option_value("background", "light", {})
      vim.cmd("colorscheme catppuccin-latte")
    end,
  },
}
