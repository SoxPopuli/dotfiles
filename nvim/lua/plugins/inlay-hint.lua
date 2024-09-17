return {
  'felpafel/inlay-hint.nvim',
  enabled = false,
  event = 'LspAttach',
  config = function()
    require('inlay-hint').setup({
      virt_text_pos = 'eol',
    })

    vim.lsp.inlay_hint.enable()
  end,
}
