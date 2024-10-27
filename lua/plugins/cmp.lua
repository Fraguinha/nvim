local function is_visible(cmp) return cmp.core.view:visible() or vim.fn.pumvisible() == 1 end
return { -- override nvim-cmp plugin
  "hrsh7th/nvim-cmp",
  -- override the options table that is used in the `require("cmp").setup()` call
  opts = function(_, opts)
    -- opts parameter is the default options table
    -- the function is lazy loaded so cmp is able to be required
    local cmp = require "cmp"
    -- modify the mapping part of the table
    opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
      if is_visible(cmp) then
        local entry = cmp.get_selected_entry()
        if not entry then cmp.select_next_item { behavior = cmp.SelectBehavior.Select } end
        cmp.confirm()
      elseif vim.api.nvim_get_mode().mode ~= "c" and vim.snippet and vim.snippet.active { direction = 1 } then
        vim.schedule(function() vim.snippet.jump(1) end)
      else
        fallback()
      end
    end, { "i", "s", "c" })
    opts.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
      if is_visible(cmp) then
        local entry = cmp.get_selected_entry()
        if not entry then cmp.select_prev_item { behavior = cmp.SelectBehavior.Select } end
        cmp.confirm()
      elseif vim.api.nvim_get_mode().mode ~= "c" and vim.snippet and vim.snippet.active { direction = -1 } then
        vim.schedule(function() vim.snippet.jump(-1) end)
      else
        fallback()
      end
    end, { "i", "s", "c" })
  end,
}
