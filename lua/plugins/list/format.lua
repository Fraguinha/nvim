return {
	"stevearc/conform.nvim",
	opts = {
		notify_on_error = false,
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
		formatters_by_ft = {
			c = { "clang-format" },
			-- java = { "google-java-format" },
			ocaml = { "ocamlformat" },
			rust = { "rustfmt" },
			python = { "isort", "black" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },
			html = { "prettierd" },
			css = { "prettierd" },
			json = { "prettierd" },
			-- yaml = { "yamlfix", "yamlfmt" },
			lua = { "stylua" },
			sh = { "shfmt" },
		},
	},
}
