-- Auto format
Format_group = vim.api.nvim_create_augroup("format_group", { clear = true })

-- No automatic comments
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = Format_group,
    pattern = "*",
    command = "set formatoptions-=o"
})

-- Remove trailing whitespaces
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = Format_group,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- Remove tailing newlines
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = Format_group,
    pattern = "*",
    command = [[%s/\(\n\)\+\%$//e]],
})

-- Highlight
local highlight_group = vim.api.nvim_create_augroup("yank_highlight_group", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})
