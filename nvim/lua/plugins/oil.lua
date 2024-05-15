local function open()
  return require('oil').open()
end

local function open_float()
  return require('oil').open_float()
end

return {
  'stevearc/oil.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    default_file_explorer = false,
  },
  cmd = { 'Oil' },
  keys = {
    { '-', open, desc = 'Open oil' },
    { '<space>-', open_float, desc = 'Open oil' },
  },
}
