-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- terminal
local function navigate(direction)
  return function()
    Fraguinha.pi.navigate(direction)
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

-- pi
vim.keymap.set("n", "<leader>aa", Fraguinha.pi.toggle, { desc = "Toggle pi" })
vim.keymap.set("n", "<leader>af", Fraguinha.pi.focus, { desc = "Focus pi" })
vim.keymap.set("n", "<leader>ab", Fraguinha.pi.add_buffer, { desc = "Add buffer" })
vim.keymap.set("x", "<leader>as", Fraguinha.pi.add_selection, { desc = "Add selection" })
vim.keymap.set("n", "<leader>as", Fraguinha.pi.add_line, { desc = "Add line" })
vim.keymap.set("n", "<leader>ad", Fraguinha.pi.add_diagnostics, { desc = "Add diagnostics" })
vim.keymap.set("n", "<leader>ap", Fraguinha.pi.prompt, { desc = "Prompt pi" })
vim.keymap.set("n", "<leader>aq", Fraguinha.pi.close, { desc = "Close pi" })
