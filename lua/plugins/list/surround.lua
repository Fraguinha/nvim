return {
    "kylechui/nvim-surround",
    config = function()
        require("nvim-surround").setup(
            {
                keymaps = {
                    normal = "Sa",
                    normal_cur = "SS",
                    normal_line = "gS",
                    normal_cur_line = "gSS",
                    visual = "S",
                    visual_line = "S",
                    delete = "Sd",
                    change = "Sc",
                },
            }
        )
    end
}
