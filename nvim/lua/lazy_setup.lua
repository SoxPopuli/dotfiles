local M = {}

function M.install_lazy()
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable',
      lazypath,
    })
  end

  vim.opt.rtp:prepend(lazypath)
end

local plugins = {
  -- TODO: migrate to plugins folder
  { import = 'plugins' },

  { 'andweeb/presence.nvim', event = 'VeryLazy' },

  'tpope/vim-surround',
  'tpope/vim-repeat',

  {
    'mbbill/undotree',
    keys = {
      {
        '<leader>u',
        function()
          vim.cmd.UndotreeToggle()
        end,
        desc = 'Toggle Undotree',
      },
    },
  },

  -- Better Syntax Support
  {
    'sheerun/vim-polyglot',
    event = 'VeryLazy',
    enabled = false,
  },

  { 'nvim-tree/nvim-web-devicons', lazy = true },
  { 'rescript-lang/vim-rescript', ft = 'rescript' },
}

function M.startup()
  require('lazy').setup(plugins, {
    checker = {
      enabled = true,
      frequency = 86400, -- Once per day
    },
    dev = {
      path = '~/Code',
    },
  })
end

return M
