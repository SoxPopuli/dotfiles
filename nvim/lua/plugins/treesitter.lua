return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    build = function()
      local tsUpdate = require('nvim-treesitter.install').update({ with_sync = false })
      tsUpdate()
    end,
    config = function()
      local parser_config = require('nvim-treesitter.parsers')

      parser_config.reason = {
        install_info = {
          url = 'https://github.com/reasonml-editor/tree-sitter-reason',
          files = { 'src/parser.c', 'src/scanner.c' },
          branch = 'master',
        },
      }

      vim.api.nvim_create_autocmd({ 'FileType' }, {
        callback = function(e)
          local ft = vim.bo[e.buf].filetype

          if parser_config[ft] ~= nil then
            vim.opt.foldmethod = 'expr'
            vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
          else
            vim.opt.foldmethod = 'syntax'
          end
        end,
      })

      local ensure_installed = {
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
      }

      local setupConfig = {
        ensure_installed = ensure_installed,

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

      -- require('nvim-treesitter.config').setup(setupConfig)
      require('nvim-treesitter').setup({})
      require('nvim-treesitter').install(ensure_installed)
    end,
  },

  {
    'SoxPopuli/rainbow-delimiters.nvim',
    branch = 'rescript',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('rainbow-delimiters.setup')({
        strategy = {
          [''] = 'rainbow-delimiters.strategy.global',
          vim = 'rainbow-delimiters.strategy.local',
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
      })
    end,
  },
}
