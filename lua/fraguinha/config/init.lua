require("fraguinha.config.settings")
require("fraguinha.config.keymaps")
require("fraguinha.config.autocommands")

-- Setup diagnostics
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
	opts = opts or {}
	opts.border = opts.border or border
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
