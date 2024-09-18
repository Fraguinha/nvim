return {
  "danymat/neogen",
  opts = function(_, opts)
    opts.languages = {
      lua = { template = { annotation_convention = "ldoc" } },
      go = { template = { annotation_convention = "godoc" } },
      java = { template = { annotation_convention = "javadoc" } },
      rust = { template = { annotation_convention = "rustdoc" } },
      python = { template = { annotation_convention = "numpydoc" } },
      typescript = { template = { annotation_convention = "tsdoc" } },
      typescriptreact = { template = { annotation_convention = "tsdoc" } },
    }
  end,
}
