return {
  { 'dracula/vim', name = 'dracula', lazy = true, priority = 1000 },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    tag = 'v1.10.0',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('catppuccin-mocha')
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = true,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('tokyonight')
    end,
  },
  {
    'scottmckendry/cyberdream.nvim',
    lazy = true,
    priority = 1000,
    -- config = function()
    --   vim.cmd.colorscheme('cyberdream')
    -- end,
  },
}
