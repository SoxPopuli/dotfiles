vim.o.foldlevel = 16

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
  group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
  callback = function()
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
  end,
})

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.fsharp = {
  install_info = {
    url = vim.fn.stdpath('config') .. '/deps/tree-sitter-fsharp',
    --url = 'https://github.com/Nsidorenco/tree-sitter-fsharp',
    branch = 'main',
    files = { 'src/scanner.c', 'src/parser.c' },
    generate_requires_npm = true,
    requires_generate_from_grammar = true,
    location = 'fsharp',
  },
  filetype = 'fsharp',
}

parser_config.reason = {
  install_info = {
    url = 'https://github.com/reasonml-editor/tree-sitter-reason',
    files = { 'src/parser.c', 'src/scanner.c' },
    branch = 'master',
  },
}

local setupConfig = {
  ensure_installed = {
    'c_sharp',
    'elm',
    'fsharp',
    'json',
    'latex',
    'lua',
    'markdown',
    'ocaml',
    'ocaml_interface',
    'ocamllex',
    'regex',
    'rust',
    'scala',
    'vim',
    'yaml',
  },

  sync_install = false,

  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = {},
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn', -- set to `false` to disable one of the mappings
      node_incremental = 'gjn',
      scope_incremental = 'gjc',
      node_decremental = 'gjm',
    },
  },
  indent = {
    enable = false,
  },
}

require('nvim-treesitter.configs').setup(setupConfig)

-- This module contains a number of default definitions
local rainbow_delimiters = require('rainbow-delimiters')

vim.g.rainbow_delimiters = {
  strategy = {
    [''] = rainbow_delimiters.strategy['global'],
    vim = rainbow_delimiters.strategy['local'],
  },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks',
  },
  highlight = {
    'RainbowDelimiterRed',
    'RainbowDelimiterYellow',
    'RainbowDelimiterBlue',
    'RainbowDelimiterOrange',
    'RainbowDelimiterGreen',
    'RainbowDelimiterViolet',
    'RainbowDelimiterCyan',
  },
}
