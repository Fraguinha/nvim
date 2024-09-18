---@type LazySpec
return {
  "mfussenegger/nvim-jdtls",
  opts = function(_, opts)
    opts.settings.java.configuration.runtimes = {
      {
        name = "JavaSE-1.8",
        path = vim.fn.glob "~/.sdkman/candidates/java/8.*-amzn",
      },
      {
        name = "JavaSE-17",
        path = vim.fn.glob "~/.sdkman/candidates/java/17.*-amzn",
      },
      {
        name = "JavaSE-21",
        path = vim.fn.glob "~/.sdkman/candidates/java/21.*-amzn",
      },
    }
    opts.settings.format = {
      enabled = true,
      settings = {
        url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
        profile = "GoogleStyle",
      },
    }
    opts.settings.saveActions = {
      organizeImports = true,
    }
    opts.settings.sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    }
    opts.cmd = {
      vim.fn.glob "~/.sdkman/candidates/java/21.*-amzn/bin/java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-javaagent:" .. vim.fn.expand "$MASON/share/jdtls/lombok.jar",
      "-Xms1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
      "-jar",
      vim.fn.expand "$MASON/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
      "-configuration",
      vim.fn.expand "$MASON/share/jdtls/config",
      "-data",
      vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
    }
    opts.root_dir = require("jdtls.setup").find_root { ".git" }
  end,
}
