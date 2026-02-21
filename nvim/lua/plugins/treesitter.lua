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
    branch = 'main',
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

      local ensure_installed = {
        'c_sharp',
        'elm',
        'fsharp',
        'go',
        'javascript',
        'json',
        'jsx',
        'latex',
        'lua',
        'markdown',
        'ocaml',
        'ocaml_interface',
        'ocamllex',
        'regex',
        'rust',
        'scala',
        'tsx',
        'typescript',
        'vim',
        'yaml',
      }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'cs',
          'fsharp',
          'go',
          'javascript',
          'javascriptreact',
          'json',
          'lua',
          'markdown',
          'ocaml',
          'rust',
          'typescript',
          'typescriptreact',
          'yaml',
        },
        callback = function()
          -- syntax highlighting, provided by Neovim
          vim.treesitter.start()
          -- folds, provided by Neovim
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo.foldmethod = 'expr'
          -- indentation, provided by nvim-treesitter
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

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
