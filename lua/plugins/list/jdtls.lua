return {
	"mfussenegger/nvim-jdtls",
	config = function()
		local jdtls_group = vim.api.nvim_create_augroup("jdtls", { clear = true })
		local cache_vars = {}

		local root_files = {
			".git",
		}

		local features = {
			codelens = true,
			debugger = true,
		}

		local function get_jdtls_paths()
			if cache_vars.paths then
				return cache_vars.paths
			end

			local path = {}

			path.data_dir = vim.fn.stdpath("cache") .. "/nvim-jdtls"

			local jdtls_install = require("mason-registry").get_package("jdtls"):get_install_path()

			path.java_agent = jdtls_install .. "/lombok.jar"
			path.launcher_jar = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")

			if vim.fn.has("mac") == 1 then
				path.platform_config = jdtls_install .. "/config_mac"
			elseif vim.fn.has("unix") == 1 then
				path.platform_config = jdtls_install .. "/config_linux"
			elseif vim.fn.has("win32") == 1 then
				path.platform_config = jdtls_install .. "/config_win"
			end

			path.bundles = {}

			local java_test_path = require("mason-registry").get_package("java-test"):get_install_path()

			local java_test_bundle = vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n")

			if java_test_bundle[1] ~= "" then
				vim.list_extend(path.bundles, java_test_bundle)
			end

			local java_debug_path = require("mason-registry").get_package("java-debug-adapter"):get_install_path()

			local java_debug_bundle = vim.split(
				vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"),
				"\n"
			)

			if java_debug_bundle[1] ~= "" then
				vim.list_extend(path.bundles, java_debug_bundle)
			end

			path.runtimes = {
				{
					name = "JavaSE-1.8",
					path = vim.fn.glob("~/.sdkman/candidates/java/8.*-amzn"),
				},
				{
					name = "JavaSE-17",
					path = vim.fn.glob("~/.sdkman/candidates/java/17.*-amzn"),
				},
			}

			cache_vars.paths = path

			return path
		end

		local function enable_codelens(bufnr)
			pcall(vim.lsp.codelens.refresh)

			vim.api.nvim_create_autocmd("BufWritePost", {
				buffer = bufnr,
				group = jdtls_group,
				desc = "refresh codelens",
				callback = function()
					pcall(vim.lsp.codelens.refresh)
				end,
			})
		end

		local function enable_debugger(bufnr)
			require("jdtls").setup_dap({ hotcodereplace = "auto" })
			require("jdtls.dap").setup_dap_main_class_configs()

			local opts = { buffer = bufnr }
			vim.keymap.set("n", "<leader>df", ":lua require('jdtls').test_class()<cr>", opts)
			vim.keymap.set("n", "<leader>dn", ":lua require('jdtls').test_nearest_method()<cr>", opts)
		end

		local function jdtls_on_attach(client, bufnr)
			On_attach(client, bufnr)

			if features.debugger then
				enable_debugger(bufnr)
			end

			if features.codelens then
				enable_codelens(bufnr)
			end

			local opts = { buffer = bufnr }
			vim.keymap.set("n", "cro>", ":lua require('jdtls').organize_imports()<cr>", opts)
			vim.keymap.set("n", "crv", ":lua require('jdtls').extract_variable()<cr>", opts)
			vim.keymap.set("x", "crv", "<esc>:lua require('jdtls').extract_variable(true)<cr>", opts)
			vim.keymap.set("n", "crc", ":lua require('jdtls').extract_constant()<cr>", opts)
			vim.keymap.set("x", "crc", "<esc>:lua require('jdtls').extract_constant(true)<cr>", opts)
			vim.keymap.set("x", "crm", "<esc>:lua require('jdtls').extract_method(true)<cr>", opts)
		end

		local function jdtls_setup()
			local jdtls = require("jdtls")

			local path = get_jdtls_paths()
			local data_dir = path.data_dir .. "/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

			if cache_vars.capabilities == nil then
				jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

				local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
				cache_vars.capabilities = vim.tbl_deep_extend(
					"force",
					vim.lsp.protocol.make_client_capabilities(),
					ok_cmp and cmp_lsp.default_capabilities() or {}
				)
			end

			local cmd = {
				vim.fn.glob("~/.sdkman/candidates/java/17.*/bin/java"),
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-javaagent:" .. path.java_agent,
				"-Xms8g",
				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",
				"-jar",
				path.launcher_jar,
				"-configuration",
				path.platform_config,
				"-data",
				data_dir,
			}

			local lsp_settings = {
				java = {
					jdt = {
						ls = {
							java = {
								home = vim.fn.glob("~/.sdkman/candidates/java/17.*-amzn"),
							},
							vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m",
						},
					},
					configuration = {
						updateBuildConfiguration = "interactive",
						runtimes = path.runtimes,
					},
					eclipse = {
						downloadSources = true,
					},
					maven = {
						downloadSources = true,
					},
					signatureHelp = {
						enabled = true,
					},
					implementationsCodeLens = {
						enabled = true,
					},
					referencesCodeLens = {
						enabled = true,
					},
					references = {
						includeDecompiledSources = true,
					},
					contentProvider = {
						preferred = "fernflower",
					},
					inlayHints = {
						parameterNames = {
							enabled = "all",
						},
					},
					format = {
						enabled = true,
						settings = {
							url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
							profile = "GoogleStyle",
						},
					},
					saveActions = {
						organizeImports = true,
					},
					sources = {
						organizeImports = {
							starThreshold = 9999,
							staticStarThreshold = 9999,
						},
					},
					codeGeneration = {
						toString = {
							template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
						},
						useBlocks = true,
					},
					extendedClientCapabilities = jdtls.extendedClientCapabilities,
				},
			}

			jdtls.start_or_attach({
				cmd = cmd,
				settings = lsp_settings,
				on_attach = jdtls_on_attach,
				capabilities = cache_vars.capabilities,
				root_dir = jdtls.setup.find_root(root_files),
				flags = {
					allow_incremental_sync = true,
				},
				init_options = {
					bundles = path.bundles,
				},
			})
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = jdtls_group,
			pattern = "java",
			desc = "Setup jdtls",
			callback = jdtls_setup,
		})
	end,
}
