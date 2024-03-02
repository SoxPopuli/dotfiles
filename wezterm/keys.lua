local M = {}
local utils = require('utils')

---@diagnostic disable-next-line: undefined-field
local act = require('wezterm').action

local function mac_binds()
  return {
    -- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
    {
      key = 'LeftArrow',
      mods = 'OPT',
      action = act.SendKey({
        key = 'b',
        mods = 'ALT',
      }),
    },
    {
      key = 'RightArrow',
      mods = 'OPT',
      action = act.SendKey({ key = 'f', mods = 'ALT' }),
    },
    {
      key = 'LeftArrow',
      mods = 'CMD',
      --action = act.SendKey({ key = 'a', mods = 'CTRL' }),
      action = act.SendString('\x1b[H'),
    },
    {
      key = 'RightArrow',
      mods = 'CMD',
      action = act.SendKey({ key = 'e', mods = 'CTRL' }),
    },
  }
end

function M.maps()
  local success, system = pcall(utils.capture, 'uname -s')

  local maps = {
    {
      key = ' ',
      mods = 'SHIFT',
      action = act.SendKey({ key = '_' }),
    },
  }

  if success and system == 'Darwin' then
    utils.merge(maps, mac_binds())
  end

  return maps
end

return M
