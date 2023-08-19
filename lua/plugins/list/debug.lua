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

    vim.keymap.set("n", "<F1>", dap.step_into)
    vim.keymap.set("n", "<F2>", dap.step_over)
    vim.keymap.set("n", "<F3>", dap.step_out)
    vim.keymap.set("n", "<F5>", dap.continue)
    vim.keymap.set("n", "<F7>", dapui.toggle)
    vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
    vim.keymap.set("n", "<leader>B", function()
      dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
    end)

    dapui.setup {
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    }

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    dap.configurations.java = {
      {
        name = "Debug (Attach) - Remote 9990",
        type = "java",
        request = "attach",
        hostName = "127.0.0.1",
        port = 9991,
      },
      {
        name = "Debug (Attach) - Remote 9991",
        type = "java",
        request = "attach",
        hostName = "127.0.0.1",
        port = 9996,
      },
      {
        name = "Debug (Attach) - Remote 9995",
        type = "java",
        request = "attach",
        hostName = "127.0.0.1",
        port = 9995,
      },
      {
        name = "Debug (Attach) - Remote 9996",
        type = "java",
        request = "attach",
        hostName = "127.0.0.1",
        port = 9996,
      },
      {
        name = "Debug (Attach) - Remote 9997",
        type = "java",
        request = "attach",
        hostName = "127.0.0.1",
        port = 9997,
      },
      {
        name = "Debug (Attach) - Remote 9998",
        type = "java",
        request = "attach",
        hostName = "127.0.0.1",
        port = 9998,
      },
      {
        name = "Debug (Attach) - Remote 9999",
        type = "java",
        request = "attach",
        hostName = "127.0.0.1",
        port = 9999,
      },
    }
  end,
}
