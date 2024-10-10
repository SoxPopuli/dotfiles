return {
  'lewis6991/gitsigns.nvim',
  config = function()
    local gitsigns = require('gitsigns')
    gitsigns.setup({})

    _G.gitsigns = {
      next_hunk = function()
        vim.cmd('Gitsigns next_hunk')
      end,
      prev_hunk = function()
        vim.cmd('Gitsigns prev_hunk')
      end,
    }
  end,
  event = 'VeryLazy',
  lazy = false,
  keys = {
    {
      ']c',
      function()
        vim.go.operatorfunc = 'v:lua.gitsigns.next_hunk'
        return 'g@l'
      end,
      desc = 'Go to next git hunk',
      nowait = true,
      expr = true,
    },
    {
      '[c',
      function()
        vim.go.operatorfunc = 'v:lua.gitsigns.prev_hunk'
        return 'g@l'
      end,
      desc = 'Go to prev git hunk',
      nowait = true,
      expr = true,
    },
    { '<space>gr', '<cmd>:Gitsigns reset_hunk<cr>', desc = 'Reset hunk' },
    { '<space>gp', '<cmd>:Gitsigns preview_hunk<cr>', desc = 'Preview hunk' },
    { '<space>gP', '<cmd>:Gitsigns preview_hunk_inline<cr>', desc = 'Preview hunk inline' },
    { '<space>gs', '<cmd>:Gitsigns stage_hunk<cr>', desc = 'Stage hunk' },
    { '<space>gu', '<cmd>:Gitsigns undo_stage_hunk<cr>', desc = 'Unstage hunk' },
    { '<space>gb', '<cmd>:Gitsigns blame<cr>', desc = 'Git blame' },
    { '<space>gl', '<cmd>:Gitsigns blame_line<cr>', desc = 'Git blame current line' },
  },
}
