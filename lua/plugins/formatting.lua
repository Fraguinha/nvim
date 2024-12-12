return {
  "stevearc/conform.nvim",
  build = function()
    local jar_dir = vim.fn.stdpath("data") .. "/spring-javaformat"
    local jar_path = jar_dir .. "/spring-java-format.jar"
    vim.fn.mkdir(jar_dir, "p")
    local metadata = vim.fn.system(
      "curl -sSL 'https://repo1.maven.org/maven2/io/spring/javaformat/spring-javaformat-vscode-extension/maven-metadata.xml'"
    )
    local version = metadata:match("<release>([^<]+)</release>")
    if not version then
      vim.notify("spring-javaformat: could not resolve latest version", vim.log.levels.ERROR)
      return
    end
    local url = string.format(
      "https://repo1.maven.org/maven2/io/spring/javaformat/spring-javaformat-vscode-extension/%s/spring-javaformat-vscode-extension-%s.jar",
      version,
      version
    )
    vim.fn.system(string.format("curl -sSL -o '%s' '%s'", jar_path, url))
    vim.notify("spring-javaformat " .. version .. " installed", vim.log.levels.INFO)
  end,
  opts = {
    formatters = {
      spring_javaformat = {
        command = "java",
        args = { "-jar", vim.fn.expand("~/.local/share/nvim/spring-javaformat/spring-java-format.jar") },
        stdin = true,
      },
    },
    formatters_by_ft = {
      java = { "spring_javaformat" },
    },
    format_on_save = {
      lsp_fallback = false,
      timeout_ms = 5000,
    },
  },
}
