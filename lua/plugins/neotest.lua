return {
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "rcasia/neotest-java", config = function() end },
    opts = {
      adapters = {
        ["neotest-java"] = {},
      },
    },
  },
  {
    "rcasia/neotest-java",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
  },
}
