vim.filetype.add({
  extension = {
    nu = 'nu',
    res = 'rescript',
  },
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
  pattern = '*.nu',
  callback = function(ev)
    vim.bo[ev.buf].ft = 'nu'
  end,
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
  pattern = '*.res',
  callback = function(ev)
    vim.bo[ev.buf].ft = 'rescript'
  end,
})
