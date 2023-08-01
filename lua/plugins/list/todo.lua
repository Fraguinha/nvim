return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local todo = require("todo-comments")
        todo.setup({
            signs = false,
            keywords = {
                FIX  = { icon = " ", color = "error", alt = { "FIXME", "BUG" } },
                TODO = { icon = " ", color = "info" },
                HACK = { icon = " ", color = "warning" },
                WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
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
