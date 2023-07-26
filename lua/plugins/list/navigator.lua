return {
    "numToStr/Navigator.nvim",
    config = function()
        local nav = require("Navigator")
        nav.setup()

        vim.keymap.set({ "n", "i" }, "<C-h>", nav.left)
        vim.keymap.set({ "n", "i" }, "<C-j>", nav.down)
        vim.keymap.set({ "n", "i" }, "<C-k>", nav.up)
        vim.keymap.set({ "n", "i" }, "<C-l>", nav.right)
    end
}
