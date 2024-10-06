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
    keys = {
      {
        '<leader>ga',
        function()
          require('neogit').open({ kind = 'split_above_all' })
        end,
        desc = 'Open Neogit above all',
      },
      {
        '<leader>gf',
        function ()
          require('neogit').open({ kind = 'floating' })
        end,
        desc = "Open Neogit floating"
      },
      {
        '<leader>gt',
        function ()
          require('neogit').open({ kind = 'tab' })
        end,
        desc = "Open Neogit in new tab"
      },
      {
        '<leader>gl',
        function ()
          require('neogit').open({ kind = 'vsplit' })
        end,
        desc = "Open Neogit in vsplit"
      },
    },

    opts = {
      graph_style = 'unicode',
    },
  },
}
