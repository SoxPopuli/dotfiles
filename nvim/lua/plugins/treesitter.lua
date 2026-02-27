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

---@generic T
---@param lst T[]
---@return table<T, true>
local function set(lst)
  local output = {}
  for _, v in pairs(lst) do
    output[v] = true
  end

  return output
end

local function delete_function()
  local node = vim.treesitter.get_node()

  local function_node_names = set({
    'function_definition', -- lua
    'function_item', -- rust
    'method_definition', --typescript
  })

  -- Traverse up the tree until we find a 'block' or similar container
  -- Note: node types vary by language (e.g., 'block', 'compound_statement')
  while node do
    local ty = node:type()
    if function_node_names[ty] then
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

---@param langs string[]
local function lang_to_ft(langs)
  local overrides = {
    c_sharp = 'cs',
    jsx = 'javascriptreact',
    tsx = 'typescriptreact',
    ocaml_interface = false,
    ocamllex = false,
  }

  local output = {}
  for _, x in pairs(langs) do
    local override = overrides[x]
    if override == nil then
      table.insert(output, x)
    elseif override == false then
      goto continue
    else
      table.insert(output, override)
    end
    ::continue::
  end

  return output
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    event = 'VeryLazy',
    build = function()
      require('nvim-treesitter.install').update():wait()
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
        pattern = lang_to_ft(ensure_installed),
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
