local neotestUrl = 'nvim-neotest/neotest'

return {
  {
    'nsidorenco/neotest-vstest',
    lazy = true,
  },
  {
    neotestUrl,
    lazy = true,
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    cmd = 'Neotest',
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-vstest')({
            dap_settings = { type = 'netcoredbg' },
          }),

          require('rustaceanvim.neotest'),
        },
      })
    end,
  },
}
