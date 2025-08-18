vim.g.rustaceanvim = {
  tools = {
    float_win_config = {
      border = 'rounded',
    },
    hover_actions = {
      replace_builtin_hover = true,
    },
    enable_clippy = true,
  },
  server = {
    cmd = (function()
      -- local dir = vim.env.HOME .. '/Code/rust-analyzer/target/release/rust-analyzer'

      -- if vim.uv.fs_stat(dir) then
      --   return { dir }
      -- else
      --   return nil
      -- end
    end)(),
    on_attach = function(client, bufnr)
      require('lsp').lsp_on_attach(client, bufnr)
    end,
    default_settings = {
      ['rust-analyzer'] = {
        cargo = {
          features = 'all',
          cfgs = {
            'debug_assertions',
            'miri',
          },
        },
        check = { features = 'all', command = 'clippy', extraArgs = { '--no-deps' } },
      },
    },
  },
}

return {
  {
    -- LSP
    'mrcjkb/rustaceanvim',
    -- version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
    enabled = true,
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
