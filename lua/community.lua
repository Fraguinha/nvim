-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- Theme
  { import = "astrocommunity.colorscheme.catppuccin" },
  -- Motions
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.motion.harpoon" },
  -- Editing
  { import = "astrocommunity.editing-support.nvim-treesitter-context" },
  { import = "astrocommunity.editing-support.neogen" },
  -- LSP
  { import = "astrocommunity.lsp.nvim-lsp-file-operations" },
  -- Debugging
  { import = "astrocommunity.debugging.nvim-dap-repl-highlights" },
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  -- Testing
  { import = "astrocommunity.test.neotest" },
  -- Git
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.git.gitlinker-nvim" },
  -- Scripting
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.bash" },
  -- Documentation
  { import = "astrocommunity.pack.markdown" },
  -- Configuration
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.xml" },
  -- Docker
  { import = "astrocommunity.pack.docker" },
  -- C/C++
  { import = "astrocommunity.pack.cpp" },
  -- Java
  { import = "astrocommunity.pack.java" },
  -- Go
  { import = "astrocommunity.pack.go" },
  -- Rust
  { import = "astrocommunity.pack.rust" },
  -- Ocaml
  { import = "astrocommunity.pack.ocaml" },
  -- Python
  { import = "astrocommunity.pack.python" },
  -- SQL
  { import = "astrocommunity.pack.sql" },
  -- HTML/CSS
  { import = "astrocommunity.pack.html-css" },
  -- Javascript
  { import = "astrocommunity.pack.typescript" },
  -- Recipes
  { import = "astrocommunity.recipes.astrolsp-no-insert-inlay-hints" },
}
