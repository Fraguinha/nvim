return {
  "JavaHello/spring-boot.nvim",
  ft = { "java", "yaml", "jproperties" },
  dependencies = {
    "mfussenegger/nvim-jdtls",
    "neovim/nvim-lspconfig",
  },
  opts = {
    java_cmd = vim.fn.glob("~/.sdkman/candidates/java/25*-tem/bin/java"),
    ls_path = vim.fn.glob(
      "~/.local/share/nvim/mason/packages/vscode-spring-boot-tools/extension/language-server/spring-boot-language-server-*-exec.jar"
    ),
  },
}
