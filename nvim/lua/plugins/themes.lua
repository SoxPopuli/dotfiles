local fn = require('functional')

local themes = {
  {
    'dracula/vim',
    name = 'dracula',
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    scheme = 'catppuccin-mocha',
    config = function()
      require('catppuccin').setup({
        custom_highlights = function(C)
          local O = require('catppuccin').options
          return {
            ['@variable.member'] = { fg = C.lavender }, -- For fields.
            ['@module'] = { fg = C.lavender, style = O.styles.miscs or { 'italic' } }, -- For identifiers referring to modules and namespaces.
            ['@string.special.url'] = { fg = C.rosewater, style = { 'italic', 'underline' } }, -- urls, links and emails
            ['@type.builtin'] = { fg = C.yellow, style = O.styles.properties or { 'italic' } }, -- For builtin types.
            ['@property'] = { fg = C.lavender, style = O.styles.properties or {} }, -- Same as TSField.
            ['@constructor'] = { fg = C.sapphire }, -- For constructor calls and definitions: = { } in Lua, and Java constructors.
            ['@keyword.operator'] = { link = 'Operator' }, -- For new keyword operator
            ['@keyword.export'] = { fg = C.sky, style = O.styles.keywords },
            ['@markup.strong'] = { fg = C.maroon, style = { 'bold' } }, -- bold
            ['@markup.italic'] = { fg = C.maroon, style = { 'italic' } }, -- italic
            ['@markup.heading'] = { fg = C.blue, style = { 'bold' } }, -- titles like: # Example
            ['@markup.quote'] = { fg = C.maroon, style = { 'bold' } }, -- block quotes
            ['@markup.link'] = { link = 'Tag' }, -- text references, footnotes, citations, etc.
            ['@markup.link.label'] = { link = 'Label' }, -- link, reference descriptions
            ['@markup.link.url'] = { fg = C.rosewater, style = { 'italic', 'underline' } }, -- urls, links and emails
            ['@markup.raw'] = { fg = C.teal }, -- used for inline code in markdown and for doc in python (""")
            ['@markup.list'] = { link = 'Special' },
            ['@tag'] = { fg = C.mauve }, -- Tags like html tag names.
            ['@tag.attribute'] = { fg = C.teal, style = O.styles.miscs or { 'italic' } }, -- Tags like html tag names.
            ['@tag.delimiter'] = { fg = C.sky }, -- Tag delimiter like < > /
            ['@property.css'] = { fg = C.lavender },
            ['@property.id.css'] = { fg = C.blue },
            ['@type.tag.css'] = { fg = C.mauve },
            ['@string.plain.css'] = { fg = C.peach },
            ['@constructor.lua'] = { fg = C.flamingo }, -- For constructor calls and definitions: = { } in Lua.
            -- typescript
            ['@property.typescript'] = { fg = C.lavender, style = O.styles.properties or {} },
            ['@constructor.typescript'] = { fg = C.lavender },
            -- TSX (Typescript React)
            ['@constructor.tsx'] = { fg = C.lavender },
            ['@tag.attribute.tsx'] = { fg = C.teal, style = O.styles.miscs or { 'italic' } },
            ['@type.builtin.c'] = { fg = C.yellow, style = {} },
            ['@type.builtin.cpp'] = { fg = C.yellow, style = {} },
          }
        end,
      })
    end,
  },
  { 'folke/tokyonight.nvim', scheme = 'tokyonight' },
  { 'scottmckendry/cyberdream.nvim', scheme = 'cyberdream' },
  { 'EdenEast/nightfox.nvim', scheme = 'carbonfox' },
  { 'rebelot/kanagawa.nvim', scheme = 'kanagawa-wave' },
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
