return {
  "zbirenbaum/copilot.lua",
  opts = {
    copilot_node_command = vim.fn.expand("$HOME") .. vim.fn.glob("/.nvm/versions/node/v22.*/bin/node"),
    server = {
      type = "binary",
    },
  },
}
