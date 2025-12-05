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
        auto_integrations = true,
        ---@class Colors
        ---@field none string
        ---@field base string "#1e1e2e"
        ---@field blue string "#89b4fa"
        ---@field crust string "#11111b"
        ---@field flamingo string "#f2cdcd"
        ---@field green string "#a6e3a1"
        ---@field lavender string "#b4befe"
        ---@field mantle string "#181825"
        ---@field maroon string "#eba0ac"
        ---@field mauve string "#cba6f7"
        ---@field overlay0 string "#6c7086"
        ---@field overlay1 string "#7f849c"
        ---@field overlay2 string "#9399b2"
        ---@field peach string "#fab387"
        ---@field pink string "#f5c2e7"
        ---@field red string "#f38ba8"
        ---@field rosewater string "#f5e0dc"
        ---@field sapphire string "#74c7ec"
        ---@field sky string "#89dceb"
        ---@field subtext0 string "#a6adc8"
        ---@field subtext1 string "#bac2de"
        ---@field surface0 string "#313244"
        ---@field surface1 string "#45475a"
        ---@field surface2 string "#585b70"
        ---@field teal string "#94e2d5"
        ---@field text string "#cdd6f4"
        ---@field yellow string "#f9e2af"
        ---@param C Colors
        custom_highlights = function(C)
          local O = require('catppuccin').options
          return {
            -- Pmenu = { bg = C.none },
            FloatTitle = { bg = C.none },
            FloatBorder = { bg = C.none },
            FloatFooter = { bg = C.none },
            NormalFloat = { bg = C.none },
            ['@variable.member'] = { fg = C.lavender },                                         -- For fields.
            ['@module'] = { fg = C.lavender, style = O.styles.miscs or { 'italic' } },          -- For identifiers referring to modules and namespaces.
            ['@string.special.url'] = { fg = C.rosewater, style = { 'italic', 'underline' } },  -- urls, links and emails
            ['@type.builtin'] = { fg = C.yellow, style = O.styles.properties or { 'italic' } }, -- For builtin types.
            ['@property'] = { fg = C.lavender, style = O.styles.properties or {} },             -- Same as TSField.
            ['@constructor'] = { fg = C.sapphire },                                             -- For constructor calls and definitions: = { } in Lua, and Java constructors.
            ['@keyword.operator'] = { link = 'Operator' },                                      -- For new keyword operator
            ['@keyword.export'] = { fg = C.sky, style = O.styles.keywords },
            ['@markup.strong'] = { fg = C.maroon, style = { 'bold' } },                         -- bold
            ['@markup.italic'] = { fg = C.maroon, style = { 'italic' } },                       -- italic
            ['@markup.heading'] = { fg = C.blue, style = { 'bold' } },                          -- titles like: # Example
            ['@markup.quote'] = { fg = C.maroon, style = { 'bold' } },                          -- block quotes
            ['@markup.link'] = { link = 'Tag' },                                                -- text references, footnotes, citations, etc.
            ['@markup.link.label'] = { link = 'Label' },                                        -- link, reference descriptions
            ['@markup.link.url'] = { fg = C.rosewater, style = { 'italic', 'underline' } },     -- urls, links and emails
            ['@markup.raw'] = { fg = C.teal },                                                  -- used for inline code in markdown and for doc in python (""")
            ['@markup.list'] = { link = 'Special' },
            ['@tag'] = { fg = C.mauve },                                                        -- Tags like html tag names.
            ['@tag.attribute'] = { fg = C.teal, style = O.styles.miscs or { 'italic' } },       -- Tags like html tag names.
            ['@tag.delimiter'] = { fg = C.sky },                                                -- Tag delimiter like < > /
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
            ['@lsp.type.enumMember'] = { fg = C.peach },
            -- Rust
            ['@lsp.type.interface.rust'] = { fg = C.flamingo },
          }
        end,
      })
    end,
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
    x.event = 'UIEnter'

    local scheme_name = x.scheme or x.name or theme_name

    local old_config = x.config
    x.config = function()
      if old_config then
        old_config()
      end
      vim.cmd.colorscheme(scheme_name)
    end
  else
    x.lazy = true
  end

  return x
end)

return themes
