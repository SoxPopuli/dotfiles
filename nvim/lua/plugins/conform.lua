local misc = require('misc')

local function apply_formatting(bufnr)
  local conform = require('conform')

  ---@type string
  local mode = vim.fn.mode():lower():sub(1, 1)

  --[[
   [  local range = (function ()
   [      local function tuple(pos)
   [          return { pos[2], pos[3] }
   [      end
   [
   [      if mode == 'v' then
   [          local first = tuple(vim.fn.getpos('v'))
   [          local last = tuple(vim.fn.getpos('.'))
   [
   [          if first[0] < last[0] then
   [              return { ["start"] = first, ["end"] = last }
   [          else
   [              return { ["start"] = last, ["end"] = first }
   [          end
   [      end
   [
   [      return nil
   [  end)()
   ]]

  local opts = {
    bufnr = bufnr,
    async = true,
    lsp_format = 'last',
    --range = range,
  }

  local bufname = vim.api.nvim_buf_get_name(0)

  local notify_level = vim.log.levels.INFO
  local notify_key = 'formatting-key'

  vim.notify(bufname, notify_level, { key = notify_key, annote = 'Formatting' })
  conform.format(opts, function()
    vim.notify(bufname, notify_level, { key = notify_key, annote = 'Formatted' })
  end)
end

local formatter_path = misc.build_path({
  vim.fn.stdpath('data'),
  'mason',
  'bin',
})

local function path(name)
  return misc.build_path({ formatter_path, name })
end

return {
  {
    'ocaml-mlx/ocaml_mlx.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('lsp').setup()
      require('ocaml_mlx')
      vim.cmd.setfiletype('ocaml.mlx')
    end,
    event = 'BufRead *.mlx',
  },
  {
    'stevearc/conform.nvim',
    lazy = true,
    opts = {
      formatters = {
        csharpier = {
          inherit = true,
          command = path('csharpier'),
          args = { 'format', '$FILENAME' },
          stdin = false,
        },
        ocamlformat_mlx = {
          inherit = false,
          command = 'ocamlformat-mlx',
          args = { '--name', '$FILENAME', '--impl', '-' },
          stdin = true,
        },
      },

      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettierd', 'prettier' },
        typescript = { 'prettierd', 'prettier' },
        javascriptreact = { 'prettierd', 'prettier' },
        typescriptreact = { 'prettierd', 'prettier' },
        fsharp = { 'fantomas' },
        ['ocaml.mlx'] = { 'ocamlformat_mlx' },
        ocaml_mlx = { 'ocamlformat_mlx' },
        markdown = { 'markdownfmt', 'cbfmt' },
        cs = { 'csharpier', lsp_format = 'fallback' },
      },
    },

    cmd = {
      'ConformInfo',
    },

    keys = {
      {
        '<space>f',
        function()
          local current_buffer = vim.api.nvim_get_current_buf()
          apply_formatting(current_buffer)
        end,
        desc = 'Format buffer',
        mode = { 'n', 'v' },
      },
    },
  },
}
