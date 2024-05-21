On_attach = function(_, bufnr)
	local telescope = require("telescope.builtin")

	vim.keymap.set("n", "gd", telescope.lsp_definitions, { buffer = bufnr })
	vim.keymap.set("n", "gt", telescope.lsp_type_definitions, { buffer = bufnr })
	vim.keymap.set("n", "gr", telescope.lsp_references, { buffer = bufnr })
	vim.keymap.set("n", "gi", telescope.lsp_implementations, { buffer = bufnr })

	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr })
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr })

	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr })

	vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { buffer = bufnr })
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })

	vim.api.nvim_create_autocmd("CursorHold", {
		buffer = bufnr,
		callback = function()
			local opts = {
				focusable = false,
				close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
				scope = "cursor",
			}
			vim.diagnostic.open_float(nil, opts)
		end,
	})
end

return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		{
			"neovim/nvim-lspconfig",
		},
		{
			"williamboman/mason.nvim",
			opts = {},
		},
		{
			"j-hui/fidget.nvim",
			opts = {},
		},
		{
			"folke/neodev.nvim",
			opts = {},
		},
	},
	config = function()
		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = {
								"${3rd}/luv/library",
								unpack(vim.api.nvim_get_runtime_file("", true)),
							},
						},
						completion = {
							callSnippet = "Replace",
						},
						telemetry = { enable = false },
					},
				},
			},
			clangd = {},
			jdtls = {},
			ocamllsp = {
				extendedHover = {
					enable = true,
				},
				codelens = {
					enable = true,
				},
			},
			rust_analyzer = {},
			pylsp = {},
			tsserver = {},
			cssls = {},
			tailwindcss = {},
			lemminx = {},
			jsonls = {},
			yamlls = {},
			bashls = {},
			dockerls = {},
			docker_compose_language_service = {},
			texlab = {},
		}

		local mason_lspconfig = require("mason-lspconfig")
		local cmp_lsp = require("cmp_nvim_lsp")

		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())

		mason_lspconfig.setup_handlers({
			function(server_name)
				if server_name == "jdtls" then
					return
				end

				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
					on_attach = On_attach,
					settings = servers[server_name],
				})
			end,
		})
	end,
}
