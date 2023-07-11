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

        vim.keymap.set("n", "<C-g>", ":Neogit<CR>")
    end
}
