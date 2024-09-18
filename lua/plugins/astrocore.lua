-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = true,
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      n = {
        -- fix change
        ["c"] = {
          [["_c]],
          desc = "Change without replacing clipboard register",
        },
        -- neotree
        ["<Tab><Tab>"] = {
          function()
            if vim.bo.filetype == "neo-tree" then
              vim.cmd.Neotree "close"
            else
              vim.cmd.Neotree "focus"
            end
          end,
          desc = "Toggle Explorer Focus",
        },
        -- debug
        ["<Leader>dd"] = {
          function()
            local remote_config = function(filetype)
              local host_name = vim.fn.input "Debug hostname [default: 127.0.0.1]: "
              local port = vim.fn.input "Debug port: "

              if host_name == "" then host_name = "127.0.0.1" end

              local config = {
                name = "Debug (Attach) - Remote " .. port,
                type = filetype,
                request = "attach",
                hostName = host_name,
                port = port,
              }

              return config
            end

            local executable_config = function(filetype)
              local executable = vim.fn.input { "Debug executable: ", vim.fn.getcwd() .. "/", "file" }

              local config = {
                type = "codelldb",
                request = "launch",
                program = executable,
                cwd = "${workspaceFolder}",
                terminal = "integrated",
                sourceLanguages = { filetype },
              }

              return config
            end

            local dap = require "dap"

            local filetype = vim.bo.filetype
            local mode = vim.fn.input "Debug mode [remote|executable]: "

            local config = {}
            if mode == "" or string.find("remote", mode) then
              config = remote_config(filetype)
            elseif string.find("executable", mode) then
              config = executable_config(filetype)
            end

            if not dap.configurations[filetype] then
              dap.configurations[filetype] = {}
              table.insert(dap.configurations[filetype], config)
            end

            dap.run(config)
          end,
          desc = "Start debugging",
        },
      },
      x = {
        -- fix paste
        ["p"] = {
          function()
            local function cursor_in_last_word()
              local line = vim.api.nvim_get_current_line()
              local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1

              local words = vim.split(line, "%s+")
              local last_word = words[#words]

              local last_word_start = #line - #last_word + 1

              return cursor_col >= last_word_start and cursor_col <= #line
            end

            if cursor_in_last_word() then
              vim.cmd [[norm "_dp]]
            else
              vim.cmd [[norm "_dP]]
            end
          end,
          desc = "Paste without replacing clipboard register",
        },
      },
    },
    -- Autocommands
    autocmds = {
      format = {
        {
          event = { "BufWritePre" },
          desc = "Remove trailing whitespaces",
          callback = function() vim.cmd [[%s/\s\+$//e]] end,
        },
        {
          event = { "BufWritePre" },
          desc = "Remove trailing newlines",
          callback = function() vim.cmd [[%s/\(\n\)\+\%$//e]] end,
        },
      },
    },
    -- Configure project root detection, check status with `:AstroRootInfo`
    rooter = {
      -- automatically update working directory (update manually with `:AstroRoot`)
      autochdir = true,
      -- list of detectors in order of prevalence, elements can be:
      --   "lsp" : lsp detection
      --   string[] : a list of directory patterns to look for
      --   fun(bufnr: integer): string|string[] : a function that takes a buffer number and outputs detected roots
      detector = {
        { ".git" }, -- highest priority is a version controlled parent directory
        "lsp", -- next check for workspace from running language servers
      },
    },
  },
}
