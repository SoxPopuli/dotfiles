local M = {}
local misc = require('misc')
local fn = require('functional')
local codelens = require('lsp.codelens')

local cmp = require('cmp')

-- Enable inlay hints by default
vim.lsp.inlay_hint.enable()
vim.keymap.set('n', '<leader>h', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle Inlay Hints' })

local function setup_keys()
  -- Global mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = 'Open diagnostic window' })
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })

  vim.keymap.set('n', '[e', function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, { desc = 'Previous error' })
  vim.keymap.set('n', ']e', function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, { desc = 'Next error' })

  vim.keymap.set('n', '<space>q', function()
    require('telescope.builtin').diagnostics()
  end, { desc = 'Show diagnostics' })

  --vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = 'Show diagnostics' })
end

---@param _ number
---@param bufnr number
function M.lsp_on_attach(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- Buffer local mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'Go to declaration' })
  vim.keymap.set('n', 'K', function()
    vim.lsp.buf.hover({ border = 'rounded' })
  end, opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename' })

  -- Don't override octo add comment keymap
  -- if it already exists
  local keymaps = vim.api.nvim_buf_get_keymap(bufnr, 'n')
  if not misc.contains(keymaps, function(item)
        return item.lhs == ' ca'
      end) then
    vim.keymap.set({ 'n', 'v' }, '<space>ac', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code action' })
  end

  local functions = {}
  local has_telescope, builtins = pcall(require, 'telescope.builtin')
  if has_telescope then
    functions = {
      implementation = builtins.lsp_implementations,
      symbols = builtins.lsp_dynamic_workspace_symbols,
      definitions = builtins.lsp_definitions,
      type_definitions = builtins.lsp_type_definitions,
      references = builtins.lsp_references,
    }
  else
    functions = {
      implementation = vim.lsp.buf.implementation,
      symbols = vim.lsp.buf.workspace_symbol,
      definitions = vim.lsp.buf.definition,
      type_definitions = vim.lsp.buf.type_definition,
      references = vim.lsp.buf.references,
    }
  end
  vim.keymap.set('n', 'gI', functions.implementation, { buffer = bufnr, desc = 'Go to implementation' })
  vim.keymap.set('n', '<leader>wq', functions.symbols, { buffer = bufnr, desc = 'Show workspace symbols' })
  vim.keymap.set('n', 'gd', functions.definitions, { buffer = bufnr, desc = 'Go to definition' })
  vim.keymap.set('n', '<space>D', functions.type_definitions, { buffer = bufnr, desc = 'Go to type definition' })
  vim.keymap.set('n', 'gr', functions.references, { buffer = bufnr, desc = 'Go to references' })

  vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature help' })
end

local function mason_install_list(list)
  local pack = require('mason-core.package')
  local registry = require('mason-registry')

  for _, name in pairs(list) do
    local pkg_name, pkg_ver = pack.Parse(name)
    local pkg = registry.get_package(pkg_name)
    if pkg:is_installed() == false then
      print('Installing ' .. pkg_name)
      pkg:install({ version = pkg_ver })
    end
  end
end

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local function setup_cmp()
  local luasnip = require('luasnip')
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-c>'] = cmp.mapping(cmp.mapping.abort(), { 'i', 'c' }),
      ['<CR>'] = cmp.mapping(cmp.mapping.confirm({ select = true }), { 'i' }), -- Accept currently selected item

      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
      ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp_signature_help', priority = 10 },
      { name = 'nvim_lsp',                priority = 5 },
      { name = 'luasnip',                 priority = 1 },
    }, {
      { name = 'buffer' },
      { name = 'path' },
    }),
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline' },
    }),
  })
end

function M.setup()
  setup_cmp()
  setup_keys()

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  capabilities = vim.tbl_deep_extend('force', capabilities, {
    textDocument = {
      diagnostic = {
        dynamicRegistration = true,
      },
    },
    workspace = {
      didChangeWorkspaceFolders = {
        dynamicRegistration = true,
      },
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  })

  ---@class MasonConfig
  ---@field lsps { [string]: table }
  ---@field lsp_config_only { [string]: table }
  ---@field others string[]
  ---@param lst MasonConfig
  local function lsp_setup_and_install(lst)
    ---@param name string
    ---@param config table | nil
    local function setup_with_defaults(name, config)
      local defaults = {
        on_attach = M.lsp_on_attach,
        flags = {
          debounce_text_changes = 300,
        },
        capabilities = capabilities,
      }

      local old_config = vim.lsp.config[name]

      vim.lsp.config(name, vim.tbl_deep_extend('force', defaults, old_config, config or {}))
      vim.lsp.enable(name)
    end

    local lsp_names = fn.map_pairs(lst.lsps, function(name, _)
      return name
    end)

    require('mason').setup()

    -- Mason installed binaries don't work on nixos
    -- TODO: add nix file with lsps?
    local is_nixos = vim.loop.fs_stat('/etc/nixos') ~= nil

    if is_nixos == false then
      require('mason-lspconfig').setup({
        ensure_installed = lsp_names,
        automatic_enable = {
          exclude = {
            'rust_analyzer',
            -- 'ts_ls',
          },
        },
      })
      mason_install_list(lst.others)
    end

    fn.iteri({ lst.lsps, lst.lsp_config_only }, function(x)
      fn.iter_pairs(x, function(name, config)
        setup_with_defaults(name, config)
      end)
    end)
  end

  lsp_setup_and_install({
    lsps = {
      bashls = {},
      clangd = {
        cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=verbose', '--enable-config' },
      },
      omnisharp = {
        on_attach = M.lsp_on_attach,
      },
      cssls = {
        capabilities = (function()
          capabilities.textDocument.completion.completionItem.snippetSupport = true
          return capabilities
        end)(),
      },
      elmls = {},
      html = {},
      kotlin_language_server = {},
      marksman = {},
      rescriptls = {
        on_attach = M.lsp_on_attach,
      },
      taplo = {},
      texlab = {},
      tinymist = {},
      yamlls = {},
      terraformls = {},
      ts_ls = {},
      purescriptls = {
        on_attach = M.lsp_on_attach,
        settings = {
          purescript = { addSpagoSources = true, censorWarnings = { 'ShadowedName', 'MissingTypeDeclaration' } },
        },
      },
      hls = {
        on_attach = function(client, bufnr)
          M.lsp_on_attach(client, bufnr)
          vim.keymap.set('<space>cl', vim.lsp.codelens.run, { buffer = bufnr })
        end,
        settings = {
          haskell = {
            plugin = {
              class = { -- missing class methods
                codeLensOn = true,
              },
              importLens = { -- make import lists fully explicit
                codeLensOn = true,
              },
              refineImports = { -- refine imports
                codeLensOn = true,
              },
              tactics = { -- wingman
                codeLensOn = true,
              },
              moduleName = { -- fix module names
                globalOn = true,
              },
              eval = { -- evaluate code snippets
                globalOn = true,
              },
              ['ghcide-type-lenses'] = { -- show/add missing type signatures
                globalOn = true,
              },
            },
          },
        },
      },
      pyright = {},
      lua_ls = {
        on_attach = function(client, bufnr)
          M.lsp_on_attach(client, bufnr)
        end,
        settings = {
          filetypes = { 'lua' },
          Lua = {
            hint = { enable = true },
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            semantic = { enable = false }, -- Disable semantic highlighting, treesitter is better imo
            capabilities = capabilities,
            workspace = {
              library = {
                vim.fn.expand('~/.luarocks/share/lua/5.4'),
                '/usr/share/lua/5.4',
              },
            },
          },
        },
      },
      lemminx = {
        settings = {
          xml = {
            completion = { autoCloseTags = true },
            validation = { noGrammar = 'ignore' },
          },
        },
      },
      jsonls = {
        settings = {
          json = {
            schemas = {
              {
                fileMatch = { 'package.json' },
                url = 'https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/package.json',
              },
            },
          },
        },
      },
    },
    lsp_config_only = {
      nushell = {},
      ocamllsp = {
        cmd = function()
          return { 'ocamllsp' }
        end,
        on_attach = function(client, bufnr)
          M.lsp_on_attach(client, bufnr)
          codelens.setup_codelens_refresh(bufnr)
        end,
        settings = {
          extendedHover = { enable = true },
          codelens = { enable = true },
        },
      },
    },
    others = {
      -- DAP Providers
      'netcoredbg',

      -- Formatters
      'fantomas',
      'prettier',
      'stylua',
      'cbfmt',
      'csharpier',
      -- 'markdownfmt',
      -- Linters
      'eslint_d',
      'luacheck',
      'shellcheck',
    },
  })
end

return M
