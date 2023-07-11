return {
    "zbirenbaum/copilot.lua",
    config = function()
        require('copilot').setup({
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<C-y>",
                    dismiss = "<C-e>",
                },
            },
            copilot_node_command = vim.fn.glob("~/.nvm/versions/node/v18.16.0/bin/node"),
        })
    end,
}
