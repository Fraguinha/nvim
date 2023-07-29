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

    local function start_note_in_insert(command, newlines)
      vim.cmd(command)
      vim.cmd.normal("G")
      for _ = 1, newlines do
        vim.cmd.normal("o")
      end
      vim.cmd("startinsert!")
    end

    vim.keymap.set("n", "gf", function()
      if require("obsidian").util.cursor_on_markdown_link() then
        return ":ObsidianFollowLink<CR>"
      else
        return "gf"
      end
    end, { noremap = false, expr = true })

    vim.keymap.set("n", "<leader>nq", function()
      vim.cmd("split")
      start_note_in_insert("ObsidianNew", 1)
    end)
    vim.keymap.set("n", "<leader>nn", function()
      local title = vim.fn.input("Note title: ")
      if title ~= "" then
        start_note_in_insert("ObsidianNew " .. title, 2)
      else
        start_note_in_insert("ObsidianNew", 1)
      end
    end)
    vim.keymap.set("n", "<leader>nt", function()
      start_note_in_insert("ObsidianToday", 1)
    end)
    vim.keymap.set("n", "<leader>ny", function()
      start_note_in_insert("ObsidianYesterday", 1)
    end)
    vim.keymap.set("n", "<leader>nl", ":ObsidianQuickSwitch<CR>")
    vim.keymap.set("v", "<leader>nl", ":ObsidianLink<CR>")
  end,
}
