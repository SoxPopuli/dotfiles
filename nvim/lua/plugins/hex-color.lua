return {
  'SoxPopuli/hex-color.nvim',
  lazy = true,
  config = function()
    require('hex-color')
  end,
  build = 'just deploy',
  cmd = {
    'HexColorEnable',
    'HexColorDisable',
    'HexColorRefresh',
  },
}
