-- Outline view: LSP / Treesitter driven
return {
  'stevearc/aerial.nvim',

  config = function()
    local aerial = require('aerial')

    _G.aerial = {
      next = function()
        aerial.next(1)
      end,
      prev = function()
        aerial.prev(1)
      end,
    }
  end,

  keys = {
    {
      ']a',
      function()
        vim.go.operatorfunc = 'v:lua.aerial.next'
        return 'g@l'
      end,
      desc = 'aerial: next',
      nowait = true,
      expr = true,
    },

    {
      '[a',
      function()
        vim.go.operatorfunc = 'v:lua.aerial.prev'
        return 'g@l'
      end,
      desc = 'aerial: prev',
      nowait = true,
      expr = true,
    },
    --{
    --  '<M-n>',
    --  function()
    --    require('aerial').next(1)
    --  end,
    --  nowait = true,
    --},
    --{
    --  '<M-p>',
    --  function()
    --    require('aerial').prev(1)
    --  end,
    --  nowait = true,
    --},
    {
      '<leader>a',
      function()
        require('aerial').toggle({
          focus = true,
          direction = 'right',
        })
      end,
    },
  },
}
