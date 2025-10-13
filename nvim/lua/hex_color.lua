local M = {}

local ns = vim.api.nvim_create_namespace('hex_colors')

---@param s string
---@param pattern string
---@return { start_pos: integer, end_pos: integer, content: string }[]
local function get_match_indices(s, pattern)
  local matches = {}

  local search_start = 0

  while true do
    local start_pos, end_pos, content = s:find(pattern, search_start, false)

    if start_pos == nil then
      break
    end

    table.insert(matches, {
      start_pos = start_pos,
      end_pos = end_pos,
      content = content,
    })
    ---@diagnostic disable-next-line: cast-local-type
    search_start = end_pos
  end

  return matches
end

---@param hex string
---@return string
local function get_foreground_color(hex)
  local c = tonumber(hex, 16)

  local r = bit.rshift(bit.band(c, 0xFF0000), 16)
  local g = bit.rshift(bit.band(c, 0x00FF00), 8)
  local b = bit.band(c, 0x0000FF)

  local grey = (r * 0.299) + (g * 0.587) + (b * 0.144)

  local fg = '000000'
  if grey < 167 then
    fg = 'ffffff'
  end

  return fg
end

function M.clear_highlights(bufnr)
  local buf = bufnr or vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
end

function M.highlight_hex_strings(bufnr)
  local buf = bufnr or vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  local pattern = '#(%x%x%x%x%x%x)'

  for row, line in ipairs(lines) do
    local matches = get_match_indices(line, pattern)
    for _, match in pairs(matches) do
      local hl_group = 'HexColor_' .. match.content
      if vim.fn.hlID(hl_group) == 0 then
        local style = {
          bg = '#' .. match.content,
          fg = '#' .. get_foreground_color(match.content),
        }
        vim.api.nvim_set_hl(0, hl_group, style)
      end
      vim.api.nvim_buf_set_extmark(buf, ns, row - 1, match.start_pos - 1, {
        end_col = match.end_pos,
        hl_group = hl_group,
      })
    end
  end
end

local autocmd_id = nil

function M.enable()
  autocmd_id = vim.api.nvim_create_autocmd({ 'BufEnter', 'BufRead', 'TextChanged', 'InsertLeave' }, {
    pattern = '*',
    ---@param ev AutocmdEvent
    callback = function(ev)
      M.highlight_hex_strings(ev.buf)
    end,
  })
  M.highlight_hex_strings()
end

function M.disable()
  if autocmd_id == nil then
    return
  end

  vim.api.nvim_del_autocmd(autocmd_id)
  autocmd_id = nil
  local buf = vim.api.nvim_get_current_buf()
  M.clear_highlights(buf)
end

return M
