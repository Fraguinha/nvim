return {
    "ggandor/leap.nvim",
    dependencies = {
        { "tpope/vim-repeat" },
    },
    config = function()
        local leap = require("leap")

        vim.api.nvim_set_hl(0, "LeapLabelPrimary", { fg = "red", bg = "none" })

        leap.add_default_mappings()

        vim.keymap.set("n", "s", function()
            local current_window = vim.fn.win_getid()
            require('leap').leap { target_windows = { current_window } }
        end)
    end,
}
