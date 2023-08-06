return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim"
    },
    config = function()
        local neogit = require("neogit")

        neogit.setup({
            disable_signs = true,
            disable_hint = true,
            disable_commit_confirmation = true,
            disable_builtin_notifications = true,
            kind = "replace",
            integrations = {
                diffview = true
            },
        })

        vim.keymap.set("n", "<C-g>", function()
            if vim.bo.ft == "NvimTree" then
                vim.cmd("NvimTreeClose")
                vim.cmd("Neogit")
            else
                if vim.bo.ft == "NeogitStatus" then
                    vim.cmd.normal("q")
                else
                    vim.cmd("Neogit")
                end
            end
        end)
    end,
}
