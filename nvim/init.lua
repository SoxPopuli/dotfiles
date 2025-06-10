vim.g.bigfile_size = 1024 * 1024 * 1 -- 1M
vim.g.mapleader = ','
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
vim.o.termguicolors = true -- Enable full color support

if vim.go.loadplugins then
  vim.highlight.priorities.semantic_tokens = 110

  local lazy_setup = require('lazy_setup')

  lazy_setup.install_lazy()
  lazy_setup.startup()

  vim.cmd.packadd('termdebug')
  vim.g.termdebug_wide = 1
end

-- Explicitly set shell to bash
vim.go.shell = (function()
  local result = vim.system({'whereis', 'bash'}, { text = true }):wait()

  if result.code ~= 0 then
    return vim.go.shell
  end

  local capture = result.stdout:match([[^bash: ([%w_/%-]+).*$]])
  return capture
end)()

vim.o.path = vim.o.path .. '**'
vim.o.listchars = vim.o.listchars .. ',space:·'
vim.o.fillchars = 'vert:┃'

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.o.expandtab = true
vim.o.autowrite = false
vim.o.autowriteall = false
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.smartindent = true

vim.g.filetype_fs = 'fsharp'

vim.cmd('filetype plugin indent on')
vim.cmd('filetype indent on')

vim.o.showmatch = true
vim.o.wrap = false
vim.o.scrolloff = 2

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'nv'

vim.o.cursorline = true

vim.o.foldlevel = 16

vim.o.fixeol = false -- Preserve original end of line status

require('commands')
require('filetypes')

vim.api.nvim_create_autocmd('BufReadPre', {
  pattern = '*',
  callback = function(ev)
    local buf = ev.buf
    local file = ev.file

    local fd = io.open(file, 'rb')
    if fd == nil then
      return
    end

    ---@type string
    local first_chars = fd:read(3)
    if first_chars == nil then
      return
    end

    local has_bom = (first_chars:sub(1, 2) == string.char(0xFE, 0xFF))
        or (first_chars:sub(1, 2) == string.char(0xFF, 0xFE))
        or (first_chars == string.char(0xEF, 0xBB, 0xBF))
        or (first_chars == string.char(0x00, 0x00, 0xFE, 0xFF))
        or (first_chars == string.char(0xFF, 0xFE, 0x00, 0x00))
    if has_bom then
      vim.bo[buf].bomb = true
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function(ev)
    vim.keymap.set('n', 'dd', function()
      local current_index = vim.fn.line('.')
      local qf_list = vim.fn.getqflist()
      table.remove(qf_list, current_index)

      vim.fn.setqflist(qf_list, 'r')

      vim.cmd('cfirst ' .. current_index)
      vim.cmd.copen()
    end, {
      desc = 'Remove current item',
      buffer = ev.buf,
    })
  end,
})

-- Keybinds
local set = vim.keymap.set

--set('n', 'L', 'g$')
--set('n', 'H', 'g_')

set('n', '<F1>', '<Cmd>:nohl<CR>')
set({ 'n', 'i', 'c' }, '<F2>', [[<Cmd>:set list! | set list?<CR>]])
set('n', '<A-z>', [[:set wrap! | set wrap?<CR>]])

set({ 'i', 'c' }, '<C-BS>', '<C-w>', { remap = true })
set({ 'i', 'c' }, '<C-h>', '<C-w>', { remap = true })

-- Escape terminal input with esc
set('t', '<Esc><Esc>', '<C-\\><C-n>')
set('t', '<C-p>', '<Cmd>:tabprev<CR>')
set('t', '<C-n>', '<Cmd>:tabnext<CR>')

-- Ctrl-Z undo
set('i', '<C-z>', '<cmd>:undo<cr>')

-- Ctrl-S save
set({ 'n', 'i' }, '<C-s>', '<cmd>:w<cr>')

-- Alt window switch
set('n', '<A-Up>', '<C-w><Up>', { remap = true })
set('n', '<A-Down>', '<C-w><Down>', { remap = true })
set('n', '<A-Left>', '<C-w><Left>', { remap = true })
set('n', '<A-Right>', '<C-w><Right>', { remap = true })

--set('n', '<A-k>', '<C-w>k')
--set('n', '<A-j>', '<C-w>j')
--set('n', '<A-h>', '<C-w>h')
--set('n', '<A-l>', '<C-w>l')

set('i', '<C-l>', '::')
set('i', '<S-Tab>', '<C-d>')

set('n', '<leader>p', '<C-w><C-p>', { remap = true })

-- Clipboard convenience
set({ 'n', 'v' }, '<Space>y', '"+y', { desc = 'Yank to clipboard' })
set({ 'n', 'v' }, '<Space>p', '"+p', { desc = 'Paste from clipboard' })
set({ 'n', 'v' }, '<Space><S-p>', '"+P', { desc = 'Paste (before) from clipboard' })

set({ 'n', 'v' }, '<Space>d', '"_d', { desc = 'Black hole delete' })
set({ 'n', 'v' }, '<Space>D', '"_D', { desc = 'Black hole delete' })
set({ 'n', 'v' }, '<Space>c', '"_c', { desc = 'Black hole change' })
set({ 'n', 'v' }, '<Space>C', '"_C', { desc = 'Black hole change' })

-- Maximize window
set('n', '<C-w>m', function()
  vim.api.nvim_win_set_height(0, 9999)
  vim.api.nvim_win_set_width(0, 9999)
end, { desc = 'Maximize window' })

set('n', '<C-w>x', '<cmd>:q<cr>', { desc = 'Close window' })

set('n', '<space><space>', 'a<space><Esc>h', { desc = 'Add space after cursor' })

set('n', '<space>i', 'i<space><Esc>i', { desc = 'Insert before space', remap = false })
set('n', '<space>I', 'I<space><Esc>i', { desc = 'Insert before space', remap = false })

--set('n', '<space>a', 'a<space><Esc>i', { desc = 'Append before space', remap = false })

-- Move binds
set('i', '<A-k>', '<cmd>:m .-2<cr><C-o>==', { silent = true })
set('i', '<A-j>', '<cmd>:m .+1<cr><C-o>==', { silent = true })

set('v', '<A-j>', [[:m '>+1<cr>gv=gv]], { silent = true })
set('v', '<A-k>', [[:m '<-2<cr>gv=gv]], { silent = true })

-- Jump commands
set('n', ']q', function()
  local count = vim.v.count1
  vim.cmd(count .. 'cnext')
end, { silent = true, desc = 'Next quickfix item' })
set('n', '[q', function()
  local count = vim.v.count1
  vim.cmd(count .. 'cprev')
end, { silent = true, desc = 'Previous quickfix item' })

set('n', ']b', '<cmd>:bnext<cr>', { silent = true, desc = 'Next buffer' })
set('n', '[b', '<cmd>:bprev<cr>', { silent = true, desc = 'Previous buffer' })

set('n', '<leader>j', [[<cmd>:ColDown<CR>]], { silent = true })
set('n', '<leader>k', [[<cmd>:ColUp<CR>]], { silent = true })

-- make bind
set('n', '<leader>mk', '<cmd>:make<CR>', { desc = 'Make' })

-- toggle virtual edit mode
-- (lets you move cursor to anywhere on screen)
set({ 'n', 'v' }, '<leader>v', function()
  if vim.go.virtualedit == '' then
    vim.go.virtualedit = 'all'
    print('Virtual Edit: Enabled')
  else
    vim.go.virtualedit = ''
    print('Virtual Edit: Disabled')
  end
end, { desc = 'Toggle virtual edit' })

set('n', '<space>*', function()
  local word = vim.fn.expand('<cWORD>')
  vim.cmd('/' .. word)
  vim.api.nvim_feedkeys('n', 'n', true)
end, { desc = 'Search whole word' })

set('v', '<space>/', [[y/<C-r>0<CR>]], { desc = 'Search for selection' })

-- Set indent level keymap
set('n', '<leader>s', function()
  local count = vim.v.count

  if count == 0 then
    return
  else
    vim.bo.sw = count
    print('shiftwidth set to ' .. count)
  end
end, { desc = 'Set shiftwidth' })

-- MacOS specific functionality
if vim.fn.has('mac') then
  -- Fix gx not working properly on Mac
  set('n', 'gx', '<cmd>:silent exec "!open <cWORD>"<cr>', { silent = true })
end

-- abbreviations
(function()
  local abbreviations = {
    { 'stirng', 'string' },
    { 'Stirng', 'String' },
  }

  for _, value in pairs(abbreviations) do
    vim.cmd.iabbrev(value[1] .. ' ' .. value[2])
  end
end)()

set('n', '<C-t>', function()
  vim.cmd('silent !tmux-sessionizer')
end, { silent = true, desc = 'Tmux Sessionizer' })
