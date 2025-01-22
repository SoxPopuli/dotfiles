local function get_path()
  local flutter_path = (function()
    ---@type string
    local flutter_path = vim.system({ 'whereis', 'flutter' }, { text = true }):wait().stdout:sub(10)
    if flutter_path:len() == 0 then
      return nil
    else
      return flutter_path:sub(0, -2)
    end
  end)()

  local dart_path = (function()
    if flutter_path then
      return nil
    end

    ---@type string
    local dart_path = vim.system({ 'whereis', 'dart' }, { text = true }):wait().stdout:sub(7)
    if dart_path:len() == 0 then
      return nil
    else
      return dart_path:sub(0, -2)
    end
  end)()

  return flutter_path or dart_path
end

return {
  'akinsho/flutter-tools.nvim',
  lazy = true,
  ft = 'dart',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'stevearc/dressing.nvim', -- optional for vim.ui.select
  },

  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    require('flutter-tools').setup({
      flutter_path = get_path(),
      debugger = {
        enabled = true,
        run_via_dap = true,
      },
      lsp = {
        color = { enabled = true },
        capabilities = capabilities,
        on_attach = require('lsp').lsp_on_attach,
        -- cmd = { 'dart', 'language-server', '--protocol=lsp' },
      },
    })
  end,
}
