-- Configure ejs
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.ejs = {
  install_info = {
    url = "https://github.com/tree-sitter/tree-sitter-embedded-template",
    files = { "src/parser.c" },
    requires_generate_from_grammar = true,
  },
  filetype = "ejs",
}
