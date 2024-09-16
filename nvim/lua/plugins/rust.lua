vim.g.rustaceanvim = {
  tools = {
    float_win_config = {
      border = 'rounded',
    },
    hover_actions = {
      replace_builtin_hover = true,
    },
  },
  server = {
    on_attach = function(client, bufnr)
      require('lsp').lsp_on_attach(client, bufnr)
    end,
    default_settings = {
      ['rust-analyzer'] = {
        cargo = { features = 'all' },
      },
    },
  },
}

return {
  {
    -- LSP
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    -- Crates helper
    'saecki/crates.nvim',
    tag = 'stable',
    event = { 'BufRead Cargo.toml' },
    opts = {
      completion = {
        crates = {
          enabled = true,
          max_results = 8,
          min_chars = 3,
        },
      },
      lsp = {
        enabled = true,
        on_attach = function(client, bufnr)
          require('lsp').lsp_on_attach(client, bufnr)
        end,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
}
