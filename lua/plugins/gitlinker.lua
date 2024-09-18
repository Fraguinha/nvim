return {
  "linrongbin16/gitlinker.nvim",
  event = "BufRead",
  opts = function(_, opts)
    return require("astrocore").extend_tbl(opts, {
      router = {
        browse = {
          ["^gitlab.feedzai.com"] = "https://gitlab.feedzai.com/"
            .. "{_A.ORG}/"
            .. "{_A.REPO}/-/blob/"
            .. "{_A.CURRENT_BRANCH}/"
            .. "{_A.FILE}"
            .. "#L{_A.LSTART}"
            .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
        },
      },
    })
  end,
}
