vim.g.NERDCreateDefaultMappings = 0
vim.g.NERDMenuMode = 0 -- Doesn't work with which-key?
vim.g.NERDSpaceDelims = 1 -- Add space with comments

local function get_mode_string()
  ---@type string
  local vim_mode = vim.fn.mode()
  local mode_char = vim_mode:sub(1, 1)

  if mode_char == 'n' then
    return 'n'
  elseif mode_char == 'v' or mode_char == 'V' then
    -- Leave visual mode
    local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'x', false)

    return 'x'
  end

  return nil
end

return {
  'preservim/nerdcommenter',

  keys = {
    {
      '<leader>ca',
      function()
        vim.fn['nerdcommenter#SwitchToAlternativeDelimiters'](1)
      end,
      desc = 'NERDCommenter: Switch Delimiters',
    },
    {
      '<leader>ci',
      function()
        vim.fn['nerdcommenter#Comment'](get_mode_string(), 'Invert')
      end,
      mode = { 'n', 'x' },
      desc = 'NERDCommenter: Invert',
    },
    {
      '<leader>cm',
      function()
        vim.fn['nerdcommenter#Comment'](get_mode_string(), 'Minimal')
      end,
      mode = { 'n', 'x' },
      desc = 'NERDCommenter: Minimal',
    },
    {
      '<leader>cs',
      function()
        vim.fn['nerdcommenter#Comment'](get_mode_string(), 'Sexy')
      end,
      mode = { 'n', 'x' },
      desc = 'NERDCommenter: Sexy',
    },
    {
      '<leader>cy',
      function()
        vim.fn['nerdcommenter#Comment'](get_mode_string(), 'Yank')
      end,
      mode = { 'n', 'x' },
      desc = 'NERDCommenter: Yank',
    },
    {
      '<leader>c<space>',
      function()
        vim.fn['nerdcommenter#Comment'](get_mode_string(), 'Toggle')
      end,
      mode = { 'n', 'x' },
      desc = 'NERDCommenter: Toggle',
    },
    {
      '<leader>cA',
      function()
        vim.fn['nerdcommenter#Comment'](get_mode_string(), 'Append')
      end,
      desc = 'NERDCommenter: Append',
    },
    {
      '<leader>cc',
      function()
        vim.fn['nerdcommenter#Comment'](get_mode_string(), 'Comment')
      end,
      mode = { 'n', 'x' },
      desc = 'NERDCommenter: Comment',
    },
    {
      '<leader>cl',
      function()
        vim.fn['nerdcommenter#Comment'](get_mode_string(), 'AlignLeft')
      end,
      mode = { 'n', 'x' },
      desc = 'NERDCommenter: AlignLeft',
    },
    {
      '<leader>cn',
      function()
        vim.fn['nerdcommenter#Comment'](get_mode_string(), 'Nested')
      end,
      mode = { 'n', 'x' },
      desc = 'NERDCommenter: Nested',
    },
    {
      '<leader>cu',
      function()
        vim.fn['nerdcommenter#Comment'](get_mode_string(), 'Uncomment')
      end,
      mode = { 'n', 'x' },
      desc = 'NERDCommenter: Uncomment',
    },
    {
      '<leader>c$',
      function()
        vim.fn['nerdcommenter#Comment'](get_mode_string(), 'ToEOL')
      end,
      mode = { 'n', 'x' },
      desc = 'NERDCommenter: ToEOL',
    },
  },
}

--[[
     a ➜ NERDCommenterAltDelims   
     i ➜ NERDCommenterInvert      
     m ➜ NERDCommenterMinimal     
     s ➜ NERDCommenterSexy        
     y ➜ NERDCommenterYank        
     󱁐 ➜ NERDCommenterToggle
     A ➜ NERDCommenterAppend      
     c ➜ NERDCommenterComment     
     l ➜ NERDCommenterAlignLeft   
     n ➜ NERDCommenterNested      
     u ➜ NERDCommenterUncomment   
     $ ➜ NERDCommenterToEOL
  +Prev ftFT » c                                                                                                             󱊷  close  󰁮 back
--]]
