return {
  'SoxPopuli/hex-color.nvim',
  lazy = true,
  config = function()
    require('hex-color')
  end,
  build = 'just deploy clean',
  cmd = {
    'HexColorEnable',
    'HexColorDisable',
    'HexColorRefresh',
  },
}
