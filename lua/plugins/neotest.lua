return {
  "nvim-neotest/neotest",
  optional = true,
  dependencies = { "rcasia/neotest-java", config = function() end },
  opts = function(_, opts)
    if not opts.adapters then opts.adapters = {} end
    table.insert(opts.adapters, require "neotest-java"(require("astrocore").plugin_opts "neotest-java"))
  end,
}
