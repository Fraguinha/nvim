return {
    "lewis6991/gitsigns.nvim",
    config = function()
        local gitsigns = require("gitsigns")

        gitsigns.setup {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            current_line_blame = true,
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                vim.keymap.set("n", "[c", function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return "<Ignore>"
                end, { buffer = bufnr })

                vim.keymap.set("n", "]c", function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return "<Ignore>"
                end, { buffer = bufnr })

                vim.keymap.set("n", "<leader>hs", gs.stage_hunk)
                vim.keymap.set("n", "<leader>hS", gs.stage_buffer)
                vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk)
                vim.keymap.set("n", "<leader>hr", gs.reset_hunk)
                vim.keymap.set("n", "<leader>hR", gs.reset_buffer)
                vim.keymap.set("n", "<leader>hh", gs.preview_hunk)
                vim.keymap.set("n", "<leader>hb", function() gs.blame_line { full = true } end)
                vim.keymap.set("n", "<leader>hd", gs.toggle_deleted)

                -- Text object
                vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end,
        }
    end,
}
