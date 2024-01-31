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
  font = wezterm.font('JetBrains Mono'),
  font_size = 13.0,
  color_scheme = 'catppuccin-mocha',
  enable_tab_bar = false,
}

if wezterm.config_builder then
  merge(config, wezterm.config_builder())
end

return config
