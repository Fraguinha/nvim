---@class Fraguinha.Github
local M = {}

function M.open_in_neovim()
  local url = vim.fn.input("GitHub URL: ")
  if url == "" then
    return
  end

  local file_path = url:match("github%.com/[^/]+/[^/]+/blob/[^/]+/([^#?]+)")
  local start_line = tonumber(url:match("#L(%d+)"))

  if not file_path then
    vim.notify("Could not parse GitHub URL", vim.log.levels.ERROR)
    return
  end

  local buf_dir = vim.fn.expand("%:p:h")
  if buf_dir == "" then
    buf_dir = vim.fn.getcwd()
  end

  local git_root =
    vim.fn.system("git -C " .. vim.fn.shellescape(buf_dir) .. " rev-parse --show-toplevel"):gsub("\n", "")
  if vim.v.shell_error ~= 0 then
    vim.notify("Not in a git repository", vim.log.levels.ERROR)
    return
  end

  vim.cmd("edit " .. vim.fn.fnameescape(git_root .. "/" .. file_path))

  if start_line then
    vim.api.nvim_win_set_cursor(0, { start_line, 0 })
    vim.cmd("normal! zz")
  end
end

return M
