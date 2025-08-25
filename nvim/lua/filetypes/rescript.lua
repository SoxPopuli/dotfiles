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

-- local function set_highlight_groups()
--   local function hl(from, to)
--     if type(from) == 'table' then
--       for _, value in pairs(from) do
--         vim.api.nvim_set_hl(0, value, { link = to })
--       end
--     else
--       vim.api.nvim_set_hl(0, from, { link = to })
--     end
--   end

--   hl({ '@lsp.type.namespace.rescript', '@module.rescript' }, 'Tag')
--   hl('@tag.attribute.rescript', '@variable.parameter')
--   hl('@constructor.rescript', 'Label')
-- end

-- local function refresh_diagnostics(buf)
--   local clients = vim.lsp.get_clients({ bufnr = buf })

--   for _, client in ipairs(clients) do
--     local name = client.name
--     -- vim.cmd({ cmd = 'LspRestart', args = { name } })
--     client:notify('textDocument/diagnostic', {
--       textDocument = vim.lsp.util.make_text_document_params(),
--     })
--   end

--   -- vim.lsp.enable('rescriptls', false)
--   -- vim.lsp.enable('rescriptls', true)
-- end

---@param event AutocmdEvent
function M.setup(event)
  vim.keymap.set('n', '<M-i>', switch_file)
  vim.keymap.set('n', '<M-o>', switch_to_generated)

  -- vim.api.nvim_create_autocmd('SafeState', {
  --   callback = function(_)
  --     set_highlight_groups()
  --   end,
  --   once = true,
  --   buffer = event.buf,
  -- })
end

return M
