local M = {}

---Merges elements from second into first
---@param first table
---@param second table
function M.merge(first, second)
  local offset = #first
  for idx, value in ipairs(second) do
    first[idx + offset] = value
  end
end

---Run cmd, capturing stdout
---@param cmd string
---@param raw boolean
---@return string
function M.capture(cmd, raw)
  local io = require('io')

  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end


return M
