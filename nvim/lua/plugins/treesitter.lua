---@generic T
---@param lst T[]
---@param item T
---@return boolean
local function contains(lst, item)
  for _, value in pairs(lst) do
    if value == item then
      return true
    end
  end

  return false
end

local function delete_function()
  local node = vim.treesitter.get_node()

  local function_node_names = {
    'function_definition', -- lua
    'function_item', -- rust
  }

  -- Traverse up the tree until we find a 'block' or similar container
  -- Note: node types vary by language (e.g., 'block', 'compound_statement')
  while node do
    local ty = node:type()
    if contains(function_node_names, ty) then
      break
    else
      node = node:parent()
    end
  end

  if node == nil then
    print('No block found')
    return
  end

  -- Get range: start_row, start_col, end_row, end_col
  -- Rows are 0-indexed in the API
  local start_row, start_col, end_row, end_col = node:range()

  vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, {})
  vim.fn.cursor(start_row + 1, start_col + 1)
end

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
      vim.keymap.set('n', 'daf', delete_function)
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
