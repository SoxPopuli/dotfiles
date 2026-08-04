local M = {}

local function switch_file()
  ---@type string
  local file_ext = vim.fn.expand('%:e')
  local file_root = vim.fn.expand('%:r')

  if file_ext == 'res' then
    vim.cmd.e(file_root .. '.resi')
  else
    vim.cmd.e(file_root .. '.res')
  end
end

local function switch_to_generated()
  ---@type string
  local file_ext = vim.fn.expand('%:e')
  ---@type string
  local file_root = vim.fn.expand('%:r')

  local possible_extensions = {
    'js',
    'mjs',
    'cjs',
  }

  if file_ext == 'res' then
    for _, ext in pairs(possible_extensions) do
      local file_path = file_root .. '.res.' .. ext
      if vim.uv.fs_stat(file_path) then
        vim.cmd.e(file_path)
        return
      end
    end
  else
    vim.cmd.e(file_root)
  end
end

---@param e AutocmdEvent
function M.setup(e)
  vim.keymap.set('n', '<M-i>', switch_file)
  vim.keymap.set('n', '<M-o>', switch_to_generated)

  vim.bo[e.buf].shiftwidth = 2
end

return M
