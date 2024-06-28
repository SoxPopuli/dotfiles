return {
  --{
  --  'mrcjkb/haskell-tools.nvim',
  --  version = '^3', -- Recommended
  --  lazy = false, -- This plugin is already lazy
  --  init = function()
  --    vim.g.haskell_tools = {
  --      tools = {},
  --      hls = {
  --        on_attach = function(client, bufnr, _ [>ht<])
  --          require('lsp').lsp_on_attach(client, bufnr)
  --        end,
  --        -- ...
  --      },
  --      dap = {},
  --    }
  --  end,
  --},
}
