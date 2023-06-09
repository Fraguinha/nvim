return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "nvim-telescope/telescope-file-browser.nvim" },
    },
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        -- Fuzzy find files
        vim.keymap.set("n", "<leader><leader>",
            function()
                local ok, _ = pcall(function() builtin.git_files { path_display = { "truncate" } } end)
                if not ok then
                    builtin.find_files {
                        path_display = { "truncate" },
                        file_ignore_patterns = { "node%_modules/.*", "target/.*", "_build/.*" },
                    }
                end
            end)

        -- Fuzzy find buffers
        vim.keymap.set("n", "<C-b>",
            function()
                builtin.buffers {
                    path_display = { "truncate" },
                    sort_lastused = true,
                    ignore_current_buffer = true
                }
            end)

        -- Fuzzy find word
        vim.keymap.set("n", "<C-f>", function() builtin.live_grep { path_display = { "truncate" } } end)
        vim.keymap.set("v", "<C-f>", function() builtin.grep_string { path_display = { "truncate" } } end)

        -- Projects
        vim.keymap.set("n", "<C-p>", function()
            vim.cmd [[:silent %bd!]]
            telescope.extensions.projects.projects {}
        end)

        -- Help
        vim.keymap.set("n", "<leader>fd", builtin.diagnostics)
        vim.keymap.set("n", "<leader>fh", builtin.help_tags)
        vim.keymap.set("n", "<leader>fk", builtin.keymaps)
        vim.keymap.set("n", "<leader>fm", builtin.man_pages)

        -- Git
        vim.keymap.set("n", "<leader>gs", builtin.git_status)
        vim.keymap.set("n", "<leader>gc", builtin.git_commits)
        vim.keymap.set("n", "<leader>gB", builtin.git_bcommits)
        vim.keymap.set("n", "<leader>gb", builtin.git_branches)
        vim.keymap.set("n", "<leader>gS", builtin.git_stash)

        telescope.setup({
            defaults = {
                layout_strategy = "flex",
                layout_config = {
                    width = 0.99,
                    height = 0.99,
                },
            },
            pickers = {
                git_commits = {
                    layout_strategy = "vertical",
                },
                git_bcommits = {
                    layout_strategy = "vertical",
                },
                git_status = {
                    layout_strategy = "vertical",
                },
            },
            extensions = {
                ui_select = {
                    require("telescope.themes").get_dropdown {}
                },
                file_browser = {},
            },
        })

        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")
        telescope.load_extension("file_browser")
        telescope.load_extension('projects')
    end,
}
