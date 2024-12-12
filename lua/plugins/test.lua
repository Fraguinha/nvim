return {
  { "rcasia/neotest-java" },
  { "nvim-neotest/neotest-jest" },
  { "marilari88/neotest-vitest" },
  {
    "nvim-neotest/neotest",
    opts = { adapters = { "neotest-java", "neotest-jest", "neotest-vitest" } },
  },
}
