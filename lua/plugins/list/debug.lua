return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"

    require("mason-nvim-dap").setup {
      automatic_setup = true,
      handlers = {},
      ensure_installed = { "codelldb", "java-debug-adapter", "java-test", "js-debug-adapter" },
    }

    local configure_and_attach = function()
      local filetype = vim.fn.input("Debug type [" .. vim.bo.filetype .. "]: ")
      local host_name = vim.fn.input("Debug hostname [127.0.0.1]: ")
      local port = vim.fn.input("Debug port: ")

      if filetype == "" then
        filetype = vim.bo.filetype
      end

      if host_name == "" then
        host_name = "127.0.0.1"
      end

      local config = {
        name = "Debug (Attach) - Remote " .. port,
        type = filetype,
        request = "attach",
        hostName = host_name,
        port = port,
      }

      if not dap.configurations[filetype] then
        dap.configurations[filetype] = {}
        table.insert(dap.configurations[filetype], config)
      end

      dap.run(config)
    end

    vim.keymap.set("n", "<F1>", dap.step_into)
    vim.keymap.set("n", "<F2>", dap.step_over)
    vim.keymap.set("n", "<F3>", dap.step_out)
    vim.keymap.set("n", "<F5>", configure_and_attach)
    vim.keymap.set("n", "<F7>", dapui.toggle)
    vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
    vim.keymap.set("n", "<leader>B", function()
      dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
    end)

    dapui.setup()

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close
  end,
}
