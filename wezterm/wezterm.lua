local wezterm = require('wezterm')
local keys = require('keys')
local utils = require('utils')

---@class WeztermConfig
local config = {
  font = wezterm.font_with_fallback({
    { family = 'JetBrains Mono', weight = "Bold" },
    'Symbols Nerd Font',
  }),
  font_size = 12.0,
  harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
  -- color_scheme = 'catppuccin-mocha',
  color_scheme = 'tokyonight_moon',
  enable_tab_bar = false,

  front_end = 'WebGpu',

  audible_bell = 'Disabled',

  foreground_text_hsb = {
    hue = 1.0,
    saturation = 1.0,
    --saturation = 1.2,
    brightness = 1.2,
  },

  force_reverse_video_cursor = true,
  colors = {
    --foreground = '#ffffff',
    cursor_fg = 'black',
    cursor_bg = 'white',
  },

  keys = keys.maps()
}

if wezterm.config_builder then
  utils.merge(config, wezterm.config_builder())
end

return config
