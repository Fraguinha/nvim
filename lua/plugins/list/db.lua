return {
    "tpope/vim-dadbod",
    dependencies = {
        "kristijanhusak/vim-dadbod-ui",
        "kristijanhusak/vim-dadbod-completion",
    },
    config = function()
        vim.keymap.set("n", "<C-h>", function()
            vim.cmd("NvimTreeClose")
            if vim.bo.ft == "NeogitStatus" then
                vim.cmd.normal("q")
            end
            vim.cmd("DBUIToggle")
        end)
    end,
}
