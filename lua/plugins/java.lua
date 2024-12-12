local config = {}

if vim.fn.has("mac") == 1 then
  config.shared_config_path = "config_mac"
elseif vim.fn.has("unix") == 1 then
  config.shared_config_path = "config_linux"
elseif vim.fn.has("win") == 1 then
  config.shared_config_path = "config_win"
end

return {
  "mfussenegger/nvim-jdtls",
  opts = {
    cmd = {
      vim.fn.glob("~/.sdkman/candidates/java/21.*-amzn/bin/java"),
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Dosgi.checkConfiguration=true",
      string.format(
        "-Dosgi.sharedConfiguration.area=%s",
        vim.fn.glob("~/.local/share/nvim/mason/packages/jdtls/") .. config.shared_config_path
      ),
      "-Dosgi.sharedConfiguration.area.readOnly=true",
      "-Dosgi.configuration.cascaded=true",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.level=ALL",
      "-Xmx1G",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
      string.format("-javaagent:%s", vim.fn.glob("~/.local/share/nvim/mason/packages/jdtls/lombok.jar")),
      "-jar",
      vim.fn.glob("~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    },
    settings = {
      java = {
        jdt = {
          ls = {
            vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xms100m -Xmx16G -Xlog:disable -Djgitver.skip=true",
          },
        },
        eclipse = {
          downloadSources = true,
        },
        import = {
          gradle = {
            enabled = false,
          },
          maven = {
            enabled = true,
          },
        },
        maven = {
          updateSnapshots = true,
          downloadSources = true,
        },
        configuration = {
          updateBuildConfiguration = "automatic",
          runtimes = {
            {
              name = "JavaSE-1.8",
              path = vim.fn.glob("~/.sdkman/candidates/java/8.*-amzn"),
              default = true,
            },
            {
              name = "JavaSE-17",
              path = vim.fn.glob("~/.sdkman/candidates/java/17.*-amzn"),
            },
            {
              name = "JavaSE-21",
              path = vim.fn.glob("~/.sdkman/candidates/java/21.*-amzn"),
            },
          },
        },
        references = {
          includeDecompiledSources = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        signatureHelp = {
          enabled = true,
        },
        implementationsCodeLens = {
          enabled = true,
        },
        inlayhints = {
          parameterNames = {
            enabled = "literals",
          },
        },
        rename = {
          enabled = true,
        },
        format = {
          enabled = true,
          comments = {
            enabled = true,
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        saveActions = {
          organizeImports = true,
        },
        cleanup = {
          actionsOnSave = {
            "qualifyMembers",
            "qualifyStaticMembers",
            "addOverride",
            "addDeprecated",
            "stringConcatToTextBlock",
            "invertEquals",
            "addFinalModifier",
            "instanceofPatternMatch",
            "lambdaExpression",
            "switchExpression",
          },
        },
      },
    },
  },
}
