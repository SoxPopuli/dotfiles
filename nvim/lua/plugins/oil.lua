local function open()
  return require('oil').open()
end

local function open_float()
  return require('oil').open_float()
end

local columns = {
  normal = { 'icon' },
  expanded = {
    'icon',
    'permissions',
    'size',
    'mtime',
  },
  is_expanded = false,
}

local function run_in_terminal()
  local entry = require('oil').get_cursor_entry()
  local name = entry.name

  local shell = vim.env.SHELL or '/bin/bash'

  local buffer = vim.api.nvim_create_buf(false, true)
  local window = vim.api.nvim_get_current_win()

  local oil_dir = require('oil').get_current_dir()

  vim.ui.input({
    prompt = 'Open in ' .. shell .. ': ',
    default = '"' .. name .. '"',
    completion = 'command',
  }, function(input)
    if input == nil then
      return
    end

    vim.api.nvim_open_win(buffer, true, {
      win = window,
      split = 'below',
    })

    vim.fn.chdir(oil_dir)

    local old_shell = vim.o.shell
    vim.o.shell = shell
    vim.cmd.term(input)
    vim.o.shell = old_shell

    local current_buf = vim.api.nvim_get_current_buf()
    local current_win = vim.api.nvim_get_current_win()

    vim.api.nvim_feedkeys('a', 'n', false)

    vim.api.nvim_create_autocmd('TermLeave', {
      callback = function()
        vim.schedule(function()
          pcall(vim.api.nvim_buf_delete, current_buf, { force = true })
          pcall(vim.api.nvim_win_close, current_win, true)
        end)
      end,
      once = true,
    })
  end)
end

return {
  'stevearc/oil.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    default_file_explorer = false,
    columns = columns.normal,
    keymaps = {
      ['gd'] = {
        function()
          if columns.is_expanded then
            require('oil').set_columns(columns.normal)
          else
            require('oil').set_columns(columns.expanded)
          end

          columns.is_expanded = not columns.is_expanded
        end,
        desc = 'Toggle expanded columns',
      },
      ['<leader>ff'] = {
        function()
          require('telescope.builtin').find_files({
            cwd = require('oil').get_current_dir(),
          })
        end,
        mode = 'n',
        nowait = true,
        desc = 'Find files in the current directory',
      },
      ['<C-;>'] = {
        run_in_terminal,
        desc = 'Run shell command for selected item',
      },
      ['<leader>:'] = {
        'actions.open_cmdline',
        opts = {
          shorten_path = true,
          modify = ':h',
        },
        desc = 'Open the command line with the current directory as an argument',
      },
    },
  },
  cmd = { 'Oil' },
  keys = {
    { '-',        open,       desc = 'Open oil' },
    { '<space>-', open_float, desc = 'Open oil' },
  },
}
