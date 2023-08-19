return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local todo = require("todo-comments")

        todo.setup({
            signs = false,
            keywords = {
                FIX  = { color = "error", alt = { "Fix", "fix", "BUG", "Bug", "bug" } },
                TODO = { color = "info", alt = { "Todo", "todo" } },
                HACK = { color = "warning", alt = { "Hack", "hack" } },
            },
            highlight = {
                before = "",
                keyword = "fg",
                after = "fg",
            },
        })

        vim.keymap.set("n", "]t", function()
            todo.jump_next()
        end)

        vim.keymap.set("n", "[t", function()
            todo.jump_prev()
        end)
    end,
}
