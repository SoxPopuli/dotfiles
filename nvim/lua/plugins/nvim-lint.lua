return {
  -- Async linting
  'mfussenegger/nvim-lint',
  event = 'VeryLazy',
  config = function()
    local lint = require('lint')

    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      bash = { 'shellcheck' },
      -- lua = { 'luacheck' },
    }

    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
      callback = function()
        --require('lint').try_lint()
      end,
    })
  end,
}
