local aerial = require('aerial')

_G.aerial = {
  next = function()
    aerial.next(1)
  end,
  prev = function()
    aerial.prev(1)
  end,
}

aerial.setup({
  on_attach = function(bufnr)
    vim.keymap.set('n', ']a', function()
      vim.go.operatorfunc = 'v:lua.aerial.next'
      return 'g@l'
    end, { buffer = bufnr, nowait = true, expr = true, desc = 'aerial: next' })
    vim.keymap.set('n', '[a', function()
      vim.go.operatorfunc = 'v:lua.aerial.prev'
      return 'g@l'
    end, { buffer = bufnr, nowait = true, expr = true, desc = 'aerial: prev' })

    vim.keymap.set('n', '<M-n>', function()
      aerial.next(1)
    end, { buffer = bufnr, nowait = true })
    vim.keymap.set('n', '<M-b>', function()
      aerial.prev(1)
    end, { buffer = bufnr, nowait = true })
  end,
  --filter_kind = false,
})

vim.keymap.set('n', '<Leader>a', function()
  aerial.toggle({
    focus = true,
    direction = 'right',
  })
end)
