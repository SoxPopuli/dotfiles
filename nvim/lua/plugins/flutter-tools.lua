local function get_path()
  local flutter_path = (function()
    ---@type string
    local flutter_path = vim.system({ 'whereis', 'flutter' }, { text = true }):wait().stdout:sub(10)
    if flutter_path:len() == 0 then
      return nil
    else
      local _, path = flutter_path:match('flutter: ([^%s]+)')
      return path
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
      local _, path = dart_path:match('dart: ([^%s]+)')
      return path
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
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          require('lsp').lsp_on_attach(client, bufnr)
          vim.lsp.document_color.enable(true, { bufnr = bufnr, })
        end,
      },
    })
  end,
}
