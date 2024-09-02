return {
  'lukas-reineke/indent-blankline.nvim',
  lazy = false,
  --version = 'v2.20.8',

  main = 'ibl',

  opts = {},

  keys = {
    {
      '<leader>id',
      function()
        vim.cmd('IndentBlanklineDisable')
        vim.cmd('IndentBlanklineDisable!')
      end,
    },
    {
      '<leader>ie',
      function()
        vim.cmd('IndentBlanklineEnable')
        vim.cmd('IndentBlanklineEnable!')
      end,
    },
    {
      '<leader>it',
      function()
        vim.cmd('IndentBlanklineToggle')
        vim.cmd('IndentBlanklineToggle!')
      end,
    },
    {
      '<leader>il',
      function()
        vim.cmd('IndentBlanklineToggle')
      end,
    },
    {
      '<leader>ir',
      function()
        vim.cmd('IndentBlanklineRefresh')
      end,
    },
  },
}
