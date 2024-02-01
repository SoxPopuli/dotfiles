local wezterm = require('wezterm')

---Merges elements from second into first
---@param first table
---@param second table
local function merge(first, second)
  for key, value in pairs(second) do
    first[key] = value
  end
end

---@class WeztermConfig
local config = {
  font = wezterm.font_with_fallback({
    { family = 'JetBrains Mono', weight = 'Bold' },
    'Symbols Nerd Font',
  }),
  font_size = 13.0,
  harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
  color_scheme = 'catppuccin-mocha',
  enable_tab_bar = false,

  audible_bell = 'Disabled',

  foreground_text_hsb = {
    hue = 1.0,
    saturation = 1.0,
    --saturation = 1.2,
    brightness = 1.2,
  },

  --colors = {
  --  foreground = '#ffffff',
  --},
}

if wezterm.config_builder then
  merge(config, wezterm.config_builder())
end

return config
