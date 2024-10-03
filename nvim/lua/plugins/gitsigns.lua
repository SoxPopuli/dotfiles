return {
  'lewis6991/gitsigns.nvim',
  opts = {},
  event = 'VeryLazy',
  lazy = false,
  keys = {
    { ']c', '<CMD>:Gitsigns next_hunk<CR>', desc = 'Go to next git hunk' },
    { '[c', '<CMD>:Gitsigns prev_hunk<CR>', desc = 'Go to prev git hunk' },
    { '<space>gr', '<cmd>:Gitsigns reset_hunk<cr>', desc = 'Reset hunk' },
    { '<space>gp', '<cmd>:Gitsigns preview_hunk<cr>', desc = 'Preview hunk' },
    { '<space>gP', '<cmd>:Gitsigns preview_hunk_inline<cr>', desc = 'Preview hunk inline' },
    { '<space>gs', '<cmd>:Gitsigns stage_hunk<cr>', desc = 'Stage hunk' },
    { '<space>gu', '<cmd>:Gitsigns undo_stage_hunk<cr>', desc = 'Unstage hunk' },
    { '<space>gb', '<cmd>:Gitsigns blame<cr>', desc = 'Git blame' },
    { '<space>gl', '<cmd>:Gitsigns blame_line<cr>', desc = 'Git blame current line' },
  },
}
