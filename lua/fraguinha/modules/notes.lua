M = {}

function M.Notes()
  local notes_dir = vim.fn.expand(vim.g.notes_dir)
  local in_notes = vim.fn.expand("%:p"):find(notes_dir)

  if not in_notes then
    vim.g._notes_previous_file = vim.fn.expand("%:p")
    vim.cmd("edit " .. notes_dir .. vim.g.notes_root)
  else
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local path = vim.api.nvim_buf_get_name(buf)
      if path:find(notes_dir) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
    vim.cmd("edit " .. vim.g._notes_previous_file)
  end
end

return M
