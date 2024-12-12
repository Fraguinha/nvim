return {
  "jakewvincent/mkdnflow.nvim",
  config = function()
    local notes_dir = vim.fn.expand(vim.g.notes_dir)

    vim.fn.mkdir(notes_dir, "p")

    require("mkdnflow").setup({
      links = {
        transform_explicit = function(text)
          text = text:gsub(" ", "-")
          text = text:lower()
          return text
        end,
      },
      perspective = {
        priority = "root",
        root_tell = vim.g.notes_root,
      },
    })
  end,
}
