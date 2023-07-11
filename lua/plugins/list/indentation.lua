return {
    "Darazaki/indent-o-matic",
    config = function()
        require('indent-o-matic').setup {
            max_lines = 2048,
            standard_widths = { 2, 4, 8 },
            skip_multiline = true,
            filetype_ = {
                standard_widths = { 2, 4 },
            },
        }
    end,
}
