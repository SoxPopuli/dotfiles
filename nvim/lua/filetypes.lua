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

local function rescript_switch_file()
  ---@type string
  local file_ext = vim.fn.expand('%:e')
  local file_root = vim.fn.expand('%:r')

  if file_ext == 'res' then
    vim.cmd.e(file_root .. '.resi')
  elseif file_ext == 'resi' then
    vim.cmd.e(file_root .. '.res')
  end
end

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
  pattern = '*.res,*.resi',
  callback = function(ev)
    vim.bo[ev.buf].ft = 'rescript'
    vim.keymap.set('n', '<M-i>', rescript_switch_file)
  end,
})
