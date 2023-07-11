return {
    "numToStr/Navigator.nvim",
    config = function()
        local nav = require("Navigator")
        nav.setup()

        vim.keymap.set("n", "<C-h>", nav.left)
        vim.keymap.set("n", "<C-j>", nav.down)
        vim.keymap.set("n", "<C-k>", nav.up)
        vim.keymap.set("n", "<C-l>", nav.right)
    end
}
