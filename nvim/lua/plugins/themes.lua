local fn = require('functional')

local themes = {
  {
    'dracula/vim',
    name = 'dracula',
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    tag = 'v1.10.0',
    scheme = 'catppuccin-mocha',
  },
  { 'folke/tokyonight.nvim',         scheme = 'tokyonight' },
  { 'scottmckendry/cyberdream.nvim', scheme = 'cyberdream' },
  { 'EdenEast/nightfox.nvim',        scheme = 'carbonfox' },
  { 'rebelot/kanagawa.nvim',         scheme = 'kanagawa-wave' },
}

local active_theme = 'catppuccin'

themes = fn.map(themes, function(x)
  x.priority = 1000

  local theme_name = x[1]
  if theme_name:find(active_theme) then
    x.lazy = false

    local scheme_name = x.scheme or x.name or theme_name

    local old_config = x.config
    x.config = function()
      if old_config then
        old_config()
      end
      vim.cmd.colorscheme(scheme_name)
      -- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    end
  else
    x.lazy = true
  end

  return x
end)

return themes
