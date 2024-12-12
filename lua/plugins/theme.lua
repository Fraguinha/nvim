local function detectable()
  local uname = (vim.uv or vim.loop).os_uname()
  if uname.sysname == "Darwin" or uname.sysname == "Windows_NT" then
    return true
  end
  if uname.release:match("WSL") or uname.release:match("orbstack") then
    return true
  end
  return vim.env.DBUS_SESSION_BUS_ADDRESS ~= nil or vim.env.DISPLAY ~= nil or vim.env.WAYLAND_DISPLAY ~= nil
end

return {
  {
    "f-person/auto-dark-mode.nvim",
    cond = detectable,
    opts = {
      set_dark_mode = function()
        vim.cmd("colorscheme catppuccin-mocha")
      end,
      set_light_mode = function()
        vim.cmd("colorscheme catppuccin-latte")
      end,
      update_interval = 3000,
      fallback = "dark",
    },
  },
}
