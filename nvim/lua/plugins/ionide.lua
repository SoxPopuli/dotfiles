vim.g['fsharp#lsp_auto_setup'] = 0
vim.g['fsharp#lsp_codelens'] = 0
vim.g['fsharp#linter'] = 1
vim.g['fsharp#unused_opens_analyzer'] = 1
vim.g['fsharp#unused_declarations_analyzer'] = 1
vim.g['fsharp#exclude_project_directories'] = { 'paket_files' }

return {
  {
    'ionide/ionide-vim',
    dependencies = {
      -- 'hrsh7th/cmp-buffer',
      -- 'hrsh7th/cmp-path',
      -- 'hrsh7th/cmp-cmdline',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
    },
    ft = 'fsharp',
    config = function()
      vim.lsp.enable('fsautocomplete', false)
      local ionide = require('ionide')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local codelens = require('lsp.codelens')

      ionide.setup({
        autostart = true,
        on_attach = function(client, bufnr)
          require('lsp').lsp_on_attach(client, bufnr)
          require('vim.lsp.codelens').on_codelens = codelens.codelens_fix()
        end,
        flags = {
          debounce_text_changes = 200,
        },
        capabilities = capabilities,
      })
    end,
  },
  {
    'SoxPopuli/fsharp-tools.nvim',
    ft = 'fsharp',
    event = { "BufRead *.fsproj" },
    build = 'just deploy',
    dev = false,
    opts = {
      indent = 2, --project file indent per tag
      max_depth = 4, --maximum level of upwards directory searches
    },
    keys = {
      {
        '<leader>f',
        function()
          require('fsharp-tools').edit_file_order(true)
        end,
      },
      {
        '<leader>F',
        function()
          require('fsharp-tools').edit_file_order(false)
        end,
      },
    },
  },
}
