local custom = {}

if vim.fn.has("mac") == 1 then
  custom.shared_config_path = "config_mac"
elseif vim.fn.has("unix") == 1 then
  custom.shared_config_path = "config_linux"
elseif vim.fn.has("win") == 1 then
  custom.shared_config_path = "config_win"
end

return {
  {
    "alessio-vivaldelli/java-creator-nvim",
    ft = "java",
    opts = {
      options = {
        java_version = 21,
        auto_open = true,
        use_notify = true,
      },
      keymaps = {
        java_new = "<leader>jn",
        java_class = "<leader>jC",
        java_interface = "<leader>jI",
        java_enum = "<leader>jE",
        java_record = "<leader>jR",
        java_abstract_class = "<leader>jA",
      },
    },
  },
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      jdtls = function(config)
        local non_osgi = { "jacocoagent%.jar$", "com%.microsoft%.java%.test%.runner%-jar%-with%-dependencies%.jar$" }
        config.init_options.bundles = vim.tbl_filter(function(jar)
          for _, pattern in ipairs(non_osgi) do
            if jar:match(pattern) then
              return false
            end
          end
          return true
        end, config.init_options.bundles)
        local ok, spring = pcall(require, "spring_boot")
        if ok then
          vim.list_extend(config.init_options.bundles, spring.java_extensions())
        end
      end,
      cmd = {
        vim.fn.glob("~/.sdkman/candidates/java/21.*-amzn/bin/java"),
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Dosgi.checkConfiguration=true",
        string.format(
          "-Dosgi.sharedConfiguration.area=%s",
          vim.fn.glob("~/.local/share/nvim/mason/packages/jdtls/") .. custom.shared_config_path
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
              vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xms100m -Xmx1G -Xlog:disable",
            },
          },
          eclipse = {
            downloadSources = true,
          },
          import = {
            gradle = {
              enabled = true,
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
              },
              {
                name = "JavaSE-17",
                path = vim.fn.glob("~/.sdkman/candidates/java/17.*-amzn"),
              },
              {
                name = "JavaSE-21",
                path = vim.fn.glob("~/.sdkman/candidates/java/21.*-amzn"),
                default = true,
              },
              {
                name = "JavaSE-25",
                path = vim.fn.glob("~/.sdkman/candidates/java/25.*-amzn"),
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
          implementationCodeLens = "all",
          inlayHints = {
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
          completion = {
            favoriteStaticMembers = {
              "org.junit.jupiter.api.Assertions.*",
              "org.mockito.Mockito.*",
            },
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*",
              "sun.*",
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
            cleanup = true,
          },
          cleanup = {
            actions = {
              "qualifyMembers",
              "qualifyStaticMembers",
              "addOverride",
              "addDeprecated",
              "stringConcatToTextBlock",
              "invertEquals",
              "addFinalModifier",
              "instanceofPatternMatch",
              "lambdaExpressionFromAnonymousClass",
              "lambdaExpression",
              "switchExpression",
              "tryWithResource",
              "renameFileToType",
              "organizeImports",
              "renameUnusedLocalVariables",
              "useSwitchForInstanceofPattern",
              "redundantComparisonStatement",
              "redundantFallingThroughBlockEnd",
              "redundantIfCondition",
              "redundantModifiers",
              "redundantSuperCall",
            },
          },
        },
      },
    },
  },
}
