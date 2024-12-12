return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      buf_ls = {},
      graphql = {
        filetypes = { "graphql", "graphqls", "gql" },
      },
    },
  },
}
