local M = {}

local function rescript_switch_file()
  ---@type string
  local file_ext = vim.fn.expand('%:e')
  local file_root = vim.fn.expand('%:r')

  if file_ext == 'res' then
    vim.cmd.e(file_root .. '.resi')
  elseif file_ext == 'resi' then
    vim.cmd.e(file_root .. '.res')
  end
end

local function set_highlight_groups()
  local function hl(from, to)
    if type(from) == 'table' then
      for _, value in pairs(from) do
        vim.api.nvim_set_hl(0, value, { link = to })
      end
    else
      vim.api.nvim_set_hl(0, from, { link = to })
    end
  end

  hl({ '@lsp.type.namespace.rescript', '@module.rescript' }, 'Tag')
  hl('@tag.attribute.rescript', '@variable.parameter')
  hl('@constructor.rescript', 'Label')
end

---@param event AutocmdEvent
function M.setup(event)
  vim.keymap.set('n', '<M-i>', rescript_switch_file)

  vim.api.nvim_create_autocmd('SafeState', {
    callback = function(_)
      set_highlight_groups()
    end,
    once = true,
    buffer = event.buf,
  })
end

return M
