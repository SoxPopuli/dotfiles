local M = {}

function M.install_lazy()
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable',
      lazypath,
    })
  end

  vim.opt.rtp:prepend(lazypath)
end

local plugins = {
  -- TODO: migrate to plugins folder
  { import = 'plugins' },

  'andweeb/presence.nvim',

  'nvim-lualine/lualine.nvim',

  'tpope/vim-surround',
  'tpope/vim-repeat',

  'preservim/nerdcommenter',
  { 'dracula/vim', name = 'dracula', lazy = true, priority = 1000 },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('catppuccin-mocha')
    end,
  },
  {
    'scalameta/nvim-metals',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ft = 'scala',
    config = function()
      local metals_config = require('metals').bare_config()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lsp = require('lsp')

      metals_config.settings = {
        showImplicitArguments = true,
        showInferredType = true,
        showImplicitConversionsAndClasses = true,
        superMethodLensesEnabled = true,
        enableSemanticHighlighting = true,
        excludedPackages = { 'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl' },
      }
      metals_config.init_options.statusBarProvider = 'on'

      metals_config.capabilities = capabilities
      metals_config.on_attach = function(client, bufnr)
        require('metals').setup_dap()
        lsp.lsp_on_attach(client, bufnr)
      end

      -- Autocmd that will actually be in charging of starting the whole thing
      local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        -- NOTE: You may or may not want java included here. You will need it if you
        -- want basic Java support but it may also conflict if you are using
        -- something like nvim-jdtls which also works on a java filetype autocmd.
        pattern = { 'scala', 'sbt', 'java' },
        callback = function()
          require('metals').initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },

  'neovim/nvim-lspconfig',
  { 'williamboman/mason.nvim', build = ':MasonUpdate' },
  { 'williamboman/mason-lspconfig.nvim', dependencies = { 'neovim/nvim-lspconfig' } },
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  {
    'simrat39/rust-tools.nvim',
    ft = 'rust',
    config = function()
      local lsp = require('lsp')
      local rt = require('rust-tools')

      rt.setup({
        server = {
          on_attach = function(client, bufnr)
            -- Hover actions
            vim.keymap.set('n', '<C-space>', rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set('n', '<Leader>a', rt.code_action_group.code_action_group, { buffer = bufnr })

            lsp.lsp_on_attach(client, bufnr)
          end,
        },
      })
    end,
  },

  'simrat39/inlay-hints.nvim',

  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp-signature-help',

  {
    'mbbill/undotree',
    keys = {
      {
        '<leader>u',
        function()
          vim.cmd.UndotreeToggle()
        end,
        desc = 'Toggle Undotree',
      },
    },
  },

  -- Debugger protocol support
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    config = function()
      local lsp_dap = require('lsp.dap')

      lsp_dap.config()
      lsp_dap.bind_keys()
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    event = { 'LspAttach' },
  },
  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      local tsUpdate = require('nvim-treesitter.install').update({ with_sync = true })
      tsUpdate()
    end,
  },

  { 'HiPhish/rainbow-delimiters.nvim', dependencies = { 'nvim-treesitter/nvim-treesitter' } },
  --use({ "~/Code/lua/rainbow-delimiters.nvim", dependencies = { "nvim-treesitter/nvim-treesitter" } })

  {
    'SoxPopuli/fsharp-tools.nvim',
    ft = { 'fsharp', 'xml' },
    build = './build.sh -r',
    dev = false,
    opts = {
      indent = 2, --project file indent per tag
      max_depth = 4, --maximum level of upwards directory searches
    },
    keys = {
      {
        '<leader>f',
        function()
          require('fsharp-tools').edit_file_order(true)
        end,
      },
      {
        '<leader>F',
        function()
          require('fsharp-tools').edit_file_order(false)
        end,
      },
    },
  },

  -- Outline view: LSP / Treesitter driven
  'stevearc/aerial.nvim',

  -- Better Syntax Support
  'sheerun/vim-polyglot',

  -- Auto pairs for '(' '[' '{'
  {
    'windwp/nvim-autopairs',
    dependencies = 'hrsh7th/nvim-cmp',
  },
  -- If you want insert `(` after select function or method item

  -- Async linting
  'mfussenegger/nvim-lint',

  { 'nvim-tree/nvim-web-devicons', lazy = true },
  { 'rescript-lang/vim-rescript', ft = 'rescript' },

  {
    'lewis6991/gitsigns.nvim',
    opts = {},
    lazy = false,
    keys = {
      { ']c', '<CMD>:Gitsigns next_hunk<CR>', desc = 'Go to next git hunk' },
      { '[c', '<CMD>:Gitsigns prev_hunk<CR>', desc = 'Go to prev git hunk' },
    },
  },
}

function M.startup()
  require('lazy').setup(plugins, {
    checker = {
      enabled = true,
      frequency = 86400, -- Once per day
    },
    dev = {
      path = '~/Code',
    },
  })
end

return M
