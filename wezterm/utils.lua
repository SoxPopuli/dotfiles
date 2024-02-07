local M = {}

---Merges elements from second into first
---@param first table
---@param second table
function M.merge(first, second)
  for key, value in pairs(second) do
    first[key] = value
  end
end

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
