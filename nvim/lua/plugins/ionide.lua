vim.g['fsharp#lsp_auto_setup'] = 0
vim.g['fsharp#lsp_codelens'] = 0
vim.g['fsharp#exclude_project_directories'] = { 'paket_files' }

return {
  'ionide/ionide-vim',
  dependencies = {
    -- 'hrsh7th/cmp-buffer',
    -- 'hrsh7th/cmp-path',
    -- 'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
  },
  ft = 'fsharp',
  config = function ()
    local ionide = require('ionide')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local codelens = require('lsp.codelens')

    ionide.setup({
        autostart = true,
        on_attach = function (client, bufnr)
          require('lsp').lsp_on_attach(client, bufnr)
          require('vim.lsp.codelens').on_codelens = codelens.codelens_fix()
        end,
        flags = {
          debounce_text_changes = 200,
        },
        capabilities = capabilities,
      })
  end
}
