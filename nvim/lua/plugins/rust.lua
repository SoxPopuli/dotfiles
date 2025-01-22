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
    -- cmd = function()
    --   local mason_registry = require('mason-registry')
    --   if mason_registry.is_installed('rust-analyzer') then
    --     -- This may need to be tweaked depending on the operating system.
    --     local ra = mason_registry.get_package('rust-analyzer')
    --     local ra_filename = ra:get_receipt():get().links.bin['rust-analyzer']
    --     return { ('%s/%s'):format(ra:get_install_path(), ra_filename or 'rust-analyzer') }
    --   else
    --     -- global installation
    --     return { 'rust-analyzer' }
    --   end
    -- end,
    -- cmd = { '/usr/local/opt/rustup/bin/rust-analyzer' },
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
          }
        },
        check = { features = 'all' },
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
