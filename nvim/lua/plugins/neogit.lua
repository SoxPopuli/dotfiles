return {
  {
    'sindrets/diffview.nvim',
    cmd = 'Diffview',
    opts = {
      hooks = {
        diff_buf_win_enter = function()
          vim.opt_local.foldenable = false
        end,
      },
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed.
      'nvim-telescope/telescope.nvim', -- optional
      -- "ibhagwan/fzf-lua",              -- optional
      -- "echasnovski/mini.pick",         -- optional
    },
    cmd = 'Neogit',

    opts = {
      graph_style = 'unicode',
    },
  },
}
