local M = {}
local misc = require('misc')
local codelens = require('lsp.codelens')

local lspconfig = require('lspconfig')
local cmp = require('cmp')
local hints = require('inlay-hints')

hints.setup({
  only_current_line = false,
  eol = {
    right_align = false,
  },
})

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
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<space>wl', function()
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
  vim.keymap.set('n', '<space>wq', functions.symbols, { buffer = bufnr, desc = 'Show workspace symbols' })
  vim.keymap.set('n', 'gd', functions.definitions, { buffer = bufnr, desc = 'Go to definition' })
  vim.keymap.set('n', '<space>D', functions.type_definitions, { buffer = bufnr, desc = 'Go to type definition' })
  vim.keymap.set('n', 'gr', functions.references, { buffer = bufnr, desc = 'Go to references' })

  vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature help' })
  -- hints.setup()
  -- hints.on_attach(client, bufnr)
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
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-space>'] = cmp.mapping.complete(),
      ['<C-c>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item

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

      ['<Down>'] = cmp.mapping.select_next_item(),
      ['<Up>'] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp_signature_help', priority = 10 },
      { name = 'nvim_lsp', priority = 5 },
      { name = 'luasnip', priority = 1 },
    }, {
      { name = 'buffer' },
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

  -- Setup Installer
  require('mason').setup()
  require('mason-lspconfig').setup({
    ensure_installed = {
      'lua_ls',
      'rust_analyzer',
      'elmls',
      'jsonls',
      'html',
      'cssls',
      'lemminx',
      'fsautocomplete',
      'yamlls',
      'marksman',
      'tsserver',
      'csharp_ls',
      'rescriptls',
      'clangd',
      'kotlin_language_server',
      'taplo',

      'bashls',
    },
  })

  mason_install_list({
    -- DAP Providers
    'netcoredbg',

    -- Linters
    'fantomas',
    'prettier',
    'stylua',
    'eslint_d',
    'luacheck',
    'shellcheck',
  })

  ---@param lsp { setup: fun(config: table) }
  ---@param config table | nil
  local function setup_with_defaults(lsp, config)
    local defaults = {
      on_attach = M.lsp_on_attach,
      flags = {
        debounce_text_changes = 300,
      },
      capabilities = capabilities,
    }

    if config ~= nil then
      config = vim.tbl_deep_extend('force', defaults, config)
    else
      config = defaults
    end

    lsp.setup(config)
  end

  setup_with_defaults(lspconfig.jsonls, {
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
  })
  setup_with_defaults(lspconfig.elmls)
  setup_with_defaults(lspconfig.html)
  setup_with_defaults(lspconfig.cssls)
  setup_with_defaults(lspconfig.yamlls)
  setup_with_defaults(lspconfig.marksman)
  setup_with_defaults(lspconfig.tsserver)
  setup_with_defaults(lspconfig.csharp_ls)
  setup_with_defaults(lspconfig.rescriptls)
  setup_with_defaults(lspconfig.clangd)
  setup_with_defaults(lspconfig.kotlin_language_server)
  setup_with_defaults(lspconfig.taplo)
  setup_with_defaults(lspconfig.bashls)

  setup_with_defaults(lspconfig.ocamllsp, {
    on_attach = function(client, bufnr)
      M.lsp_on_attach(client, bufnr)
      codelens.setup_codelens_refresh(bufnr)
    end,
    --root_dir = get_ocaml_root,
    --cmd = { misc.build_path({ get_ocaml_root(), "_opam", "bin", "ocamllsp" }) },
    settings = {
      extendedHover = { enable = true },
      codelens = { enable = true },
    },
  })

  setup_with_defaults(lspconfig.fsautocomplete, {
    on_attach = function(client, bufnr)
      M.lsp_on_attach(client, bufnr)
      require('vim.lsp.codelens').on_codelens = codelens.codelens_fix()
      codelens.setup_codelens_refresh(bufnr)
    end,
    settings = {
      FSharp = {
        keywordsAutocomplete = false,
        ExternalAutocomplete = false,
        Linter = true,
        UnionCaseStubGeneration = true,
        UnionCaseStubGenerationBody = 'failwith "todo"',
        RecordStubGeneration = true,
        RecordStubGenerationBody = 'failwith "todo"',
        InterfaceStubGeneration = true,
        InterfaceStubGenerationBody = 'failwith "todo"',
        InterfaceStubGenerationObjectIdentifier = 'this',
        ResolveNamespaces = true,
        SimplifyNameAnalyzer = true,
        UnusedOpensAnalyzer = true,
        UnusedDeclarationsAnalyzer = true,
        CodeLenses = { Signature = { Enabled = true }, References = { Enabled = true } },
        LineLens = { Enabled = 'always', Prefix = '' },
        PipelineHints = { Enabled = true, Prefix = '' },
      },
    },
  })

  setup_with_defaults(lspconfig.lemminx, {
    settings = {
      xml = {
        completion = { autoCloseTags = true },
        validation = { noGrammar = 'ignore' },
      },
    },
  })

  lspconfig.lua_ls.setup({
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
          library = {},
        },
      },
    },
  })

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
end

return M
