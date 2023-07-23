return {
    "ggandor/leap.nvim",
    dependencies = {
        { "tpope/vim-repeat" },
    },
    config = function()
        local leap = require("leap")

        vim.api.nvim_set_hl(0, "LeapLabelPrimary", { fg = "red", bg = "none" })

        vim.keymap.set("n", "s", function()
            local current_window = vim.fn.win_getid()
            leap.leap { target_windows = { current_window } }
        end)
        vim.keymap.set("o", "x", function()
            local current_window = vim.fn.win_getid()
            leap.leap { target_windows = { current_window } }
        end)

        leap.add_repeat_mappings(';', ',', {
            relative_directions = false,
            modes = { 'n', 'x', 'o' },
        })
    end,
}
