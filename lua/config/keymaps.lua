-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- terminal
local function navigate(direction)
  return function()
    Fraguinha.omp.navigate(direction)
  end
end

vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-h>", navigate("left"), { desc = "Navigate left" })
vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-j>", navigate("down"), { desc = "Navigate down" })
vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-k>", navigate("up"), { desc = "Navigate up" })
vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-l>", navigate("right"), { desc = "Navigate right" })
vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-Left>", navigate("left"), { desc = "Navigate left" })
vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-Down>", navigate("down"), { desc = "Navigate down" })
vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-Up>", navigate("up"), { desc = "Navigate up" })
vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-Right>", navigate("right"), { desc = "Navigate right" })

-- Git blame
vim.keymap.set("n", "<leader>gB", function()
  require("gitsigns").blame()
end, { desc = "Git Blame" })

-- GitHub
vim.keymap.set("n", "<leader>go", Fraguinha.github.open_in_neovim, { desc = "Open GitHub link in Neovim" })

vim.keymap.set({ "n", "x" }, "<leader>aa", Fraguinha.omp.toggle, { desc = "Toggle OMP" })
vim.keymap.set({ "n", "x" }, "<leader>af", Fraguinha.omp.focus, { desc = "Focus OMP" })
vim.keymap.set({ "n", "x" }, "<leader>ab", Fraguinha.omp.add_buffer, { desc = "Add buffer" })
vim.keymap.set("x", "<leader>as", Fraguinha.omp.add_selection, { desc = "Add selection" })
vim.keymap.set("n", "<leader>as", Fraguinha.omp.add_line, { desc = "Add line" })
vim.keymap.set("n", "<leader>ad", Fraguinha.omp.add_workspace_diagnostics, { desc = "Add workspace diagnostics" })
vim.keymap.set("x", "<leader>ad", Fraguinha.omp.add_selection_diagnostics, { desc = "Add selection diagnostics" })
vim.keymap.set("n", "<leader>aD", Fraguinha.omp.add_buffer_diagnostics, { desc = "Add buffer diagnostics" })
vim.keymap.set("n", "<leader>ap", Fraguinha.omp.prompt, { desc = "Prompt OMP" })
vim.keymap.set("x", "<leader>ap", Fraguinha.omp.prompt_selection, { desc = "Prompt OMP with selection" })
vim.keymap.set({ "n", "x" }, "<leader>aq", Fraguinha.omp.close, { desc = "Close OMP" })
