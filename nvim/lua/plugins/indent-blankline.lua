return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'VeryLazy',
  --version = 'v2.20.8',

  main = 'ibl',

  opts = { scope = { enabled = false } },

  keys = {
    {
      '<leader>id',
      function()
        vim.cmd('IBLDisable')
      end,
      desc = "Indent Blankline: Disable"
    },
    {
      '<leader>ie',
      function()
        vim.cmd('IBLEnable')
      end,
      desc = "Indent Blankline: Enable"
    },
    {
      '<leader>it',
      function()
        vim.cmd('IBLToggle')
      end,
      desc = "Indent Blankline: Toggle"
    },
  },
}
