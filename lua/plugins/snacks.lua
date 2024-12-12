return {
  "snacks.nvim",
  keys = {
    {
      "<tab><tab>",
      function()
        Snacks.picker.explorer()
      end,
      desc = "Find Files",
    },
    {
      "<leader>sp",
      function()
        Snacks.picker.projects()
      end,
      desc = "Projects",
    },
    {
      "<leader>sF",
      function()
        Snacks.picker.files({ args = { "--no-ignore" } })
      end,
      desc = "Find Files (no gitignore)",
    },
    {
      "<leader>sG",
      function()
        Snacks.picker.grep({ args = { "--no-ignore" } })
      end,
      desc = "Grep (no gitignore)",
    },
    {
      "<leader>sW",
      function()
        Snacks.picker.grep_word({ args = { "--no-ignore" } })
      end,
      desc = "Grep Word (no gitignore)",
      mode = { "n", "x" },
    },
    {
      "<leader>gb",
      function()
        Snacks.picker.git_branches({ all = true })
      end,
      desc = "Git Branches",
    },
    {
      "<leader>gy",
      function()
        Snacks.gitbrowse({
          open = function(url)
            vim.fn.setreg("+", url)
          end,
          notify = false,
        })
      end,
      desc = "Copy GitHub link to clipboard",
      mode = { "n", "v" },
    },
    {
      "<leader>gY",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Open GitHub link in browser",
      mode = { "n", "v" },
    },
  },
  opts = {
    dashboard = {
      preset = {
        header = false,
      },
      sections = {
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = { 2, 1 } },
        { icon = " ", title = "Recent Projects", section = "projects", indent = 2, padding = { 2, 1 } },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 2, 1 } },
        { section = "startup" },
      },
    },
    picker = {
      layout = {
        preset = "ivy",
        preview = false,
      },
      win = {
        input = {
          keys = {
            ["<S-Tab>"] = false,
            ["<Tab>"] = false,
            ["<space>"] = { "select_only", mode = "n" },
          },
        },
        list = {
          keys = {
            ["<S-Tab>"] = false,
            ["<Tab>"] = false,
            ["<space>"] = { "select_only", mode = "n" },
          },
        },
      },
      sources = {
        files = {
          win = {
            input = {
              keys = {
                ["<s-tab>"] = { "switch_between_pickers", mode = { "i", "n" } },
                ["<tab><tab>"] = { "close", mode = { "i", "n" } },
                ["space"] = false,
              },
            },
          },
        },
        explorer = {
          layout = { fullscreen = false, layout = { width = 80 } },
          win = {
            input = {
              keys = {
                ["<s-tab>"] = { "switch_between_pickers", mode = { "i", "n" } },
                ["<tab><tab>"] = { "close", mode = { "i", "n" } },
                ["<esc>"] = { "cycle_win", mode = { "n" } },
              },
            },
            list = {
              keys = {
                ["<s-tab>"] = { "switch_between_pickers", mode = { "i", "n" } },
                ["<tab><tab>"] = { "close", mode = { "i", "n" } },
                ["<esc>"] = false,
                ["l"] = { "select_file", mode = "n" },
                ["gs"] = { "git_stage", mode = "n" },
                ["gr"] = { "git_reset", mode = "n" },
              },
            },
          },
        },
      },
      actions = {
        select_only = function(picker)
          picker.list:select()
        end,
        select_file = function(picker)
          local item = picker:current()
          if item.dir then
            picker:action("confirm")
          else
            picker:action("confirm")
            picker:close()
          end
        end,
        switch_between_pickers = function(picker)
          local title = picker.title
          picker:close()
          if title == "Files" then
            Snacks.explorer.reveal()
          elseif title == "Explorer" then
            Snacks.picker.files()
          end
        end,
        git_stage = function(picker)
          local items = picker:selected({ fallback = true })
          for _, item in ipairs(items) do
            local toplevel = vim
              .system({ "git", "rev-parse", "--show-toplevel" }, { text = true })
              :wait().stdout
              :gsub("\n", "/")
            local staged_files = vim
              .system({ "git", "diff", "--cached", "--name-only" }, { text = true })
              :wait().stdout
              :gsub("\n", ";")
            local path = item.file:gsub(toplevel, "")
            if not staged_files:find(path) then
              vim.fn.system({ "git", "add", path })
            else
              vim.fn.system({ "git", "reset", "--", path })
            end
          end
        end,
        git_reset = function(picker)
          local items = picker:selected({ fallback = true })
          for _, item in ipairs(items) do
            local toplevel = vim
              .system({ "git", "rev-parse", "--show-toplevel" }, { text = true })
              :wait().stdout
              :gsub("\n", "/")
            local path = item.file:gsub(toplevel, "")
            vim.fn.system({ "git", "checkout", "--", path })
            vim.cmd("edit " .. path)
          end
        end,
      },
    },
  },
}
