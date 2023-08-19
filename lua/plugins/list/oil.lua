return {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local oil = require("oil")

        oil.setup()

        vim.keymap.set("n", "<Tab><Tab>", function()
            if vim.bo.ft ~= "oil" then
                oil.open()
            else
                oil.close()
            end
        end)
    end
}
