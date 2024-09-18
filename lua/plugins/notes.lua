return {
  "jakewvincent/mkdnflow.nvim",
  config = function()
    require("mkdnflow").setup {
      links = {
        transform_explicit = function(text)
          text = text:gsub(" ", "-")
          text = text:lower()
          return text
        end,
      },
      perspective = {
        priority = "root",
        root_tell = "index.md",
      },
    }

    local function toggle_notes()
      local notes_dir = vim.fn.expand "~/notes/"
      local in_notes = vim.fn.expand("%:p"):find(notes_dir)
      if not in_notes then
        vim.g.notes_previous_file = vim.fn.expand "%:p"
        vim.cmd("e " .. notes_dir .. "index.md")
      else
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          local path = vim.api.nvim_buf_get_name(buf)
          if path:find(notes_dir) then vim.api.nvim_buf_delete(buf, { force = true }) end
        end
        vim.cmd("e " .. vim.g.notes_previous_file)
      end
    end

    vim.keymap.set("n", "<BS><BS>", toggle_notes)
  end,
}
