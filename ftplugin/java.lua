-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- License
local license_template = [[/*
 * The copyright of this file belongs to Feedzai. The file cannot be
 * reproduced in whole or in part, stored in a retrieval system,
 * transmitted in any form, or by any means electronic, mechanical,
 * photocopying, or otherwise, without the prior permission of the owner.
 *
 * © YYYY Feedzai, Strictly Confidential
 */]]

local function license()
  local current_year = os.date("%Y")

  local license_with_year = license_template:gsub("YYYY", current_year)
  local license_lines = vim.split(license_with_year, "\n")

  local buffer_lines = vim.api.nvim_buf_get_lines(0, 0, 16, false)
  local buffer_string = table.concat(buffer_lines, "\n")

  local header_comment_pattern = "^%s*/%*.-%*/"

  local start_pos, end_pos = buffer_string:find(header_comment_pattern)

  if not start_pos then
    vim.api.nvim_buf_set_lines(0, 0, 0, false, license_lines)
    return
  end

  local header_comment = buffer_string:sub(start_pos, end_pos):gsub("%d%d%d%d", "YYYY")

  if header_comment == license_template then
    return
  end

  local comment_lines = vim.split(header_comment, "\n")
  vim.api.nvim_buf_set_lines(0, 0, #comment_lines, false, license_lines)
end

-- Configure license on save
local license_group = vim.api.nvim_create_augroup("license_group", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = license_group,
  pattern = "*.java",
  callback = license,
})
