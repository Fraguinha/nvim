return {
    "ggandor/leap.nvim",
    dependencies = {
        { "tpope/vim-repeat" },
    },
    config = function()
        local leap = require("leap")

        vim.api.nvim_set_hl(0, "LeapLabelPrimary", { fg = "red", bg = "none" })

        leap.add_default_mappings()
        leap.add_repeat_mappings(';', ',', {
            relative_directions = true,
            modes = { 'n', 'x', 'o' },
        })
    end,
}
