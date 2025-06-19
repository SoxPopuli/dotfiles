return {
  'iamcco/markdown-preview.nvim',

  keys = {
    { '<leader>mp', '<cmd>:MarkdownPreview<cr>' },
    { '<leader>ms', '<cmd>:MarkdownPreviewStop<cr>' },
    { '<leader>mt', '<cmd>:MarkdownPreviewToggle<cr>' },
  },

  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = 'bash -c "cd app && npm install"',
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
    if not (vim.uv.os_uname().sysname == "Darwin") then
      vim.g.mkdp_browser = 'firefox'
    end
  end,
  ft = { 'markdown' },
}
