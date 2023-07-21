return {
  "epwalsh/obsidian.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    dir = "~/workspace/obsidian",
    notes_subdir = "notes",
    daily_notes = {
      folder = "dailies",
      date_format = "%Y-%m-%d",
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
      new_notes_location = "notes_subdir"
    },
    note_id_func = function(title)
      local filename = ""
      if title ~= nil then
        filename = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        for _ = 1, 4 do
          filename = filename .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. filename
    end,
  },
  config = function(_, opts)
    require("obsidian").setup(opts)

    vim.keymap.set("n", "gf", function()
      if require("obsidian").util.cursor_on_markdown_link() then
        return ":ObsidianFollowLink<CR>"
      else
        return "gf"
      end
    end, { noremap = false, expr = true })

    vim.keymap.set("n", "<leader>nn", ":ObsidianQuickSwitch<CR>")
    vim.keymap.set("n", "<leader>nc", function()
      local title = vim.fn.input("Note title: ")
      if title ~= "" then
        vim.cmd("ObsidianNew " .. title)
      else
        vim.cmd("ObsidianNew")
      end
    end)
    vim.keymap.set("n", "<leader>nt", ":ObsidianToday<CR>")
    vim.keymap.set("n", "<leader>ny", ":ObsidianYesterday<CR>")
    vim.keymap.set("v", "<leader>nl", ":ObsidianLink<CR>")
  end,
}
