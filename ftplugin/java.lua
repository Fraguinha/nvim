vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Keymaps
vim.keymap.set("n", "<leader>dh", function()
  require("jdtls").update_debug_config()
end, { buffer = true, desc = "Hot Code Replace" })

vim.keymap.set("n", "<leader>jv", function()
  require("jdtls").extract_variable()
end, { buffer = true, desc = "Extract Variable" })
vim.keymap.set("x", "<leader>jv", function()
  require("jdtls").extract_variable(true)
end, { buffer = true, desc = "Extract Variable" })

vim.keymap.set("n", "<leader>jc", function()
  require("jdtls").extract_constant()
end, { buffer = true, desc = "Extract Constant" })
vim.keymap.set("x", "<leader>jc", function()
  require("jdtls").extract_constant(true)
end, { buffer = true, desc = "Extract Constant" })

vim.keymap.set("x", "<leader>jm", function()
  require("jdtls").extract_method(true)
end, { buffer = true, desc = "Extract Method" })
