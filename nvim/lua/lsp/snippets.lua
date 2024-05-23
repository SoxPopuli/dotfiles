local M = {}

-- Imports (as per 'luasnip.txt')
local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require('luasnip.util.events')
local ai = require('luasnip.nodes.absolute_indexer')
local extras = require('luasnip.extras')
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local conds = require('luasnip.extras.expand_conditions')
local postfix = require('luasnip.extras.postfix').postfix
local types = require('luasnip.util.types')
local parse = require('luasnip.util.parser').parse_snippet
local ms = ls.multi_snippet
local k = require('luasnip.nodes.key_indexer').new_key
--

function M.fsharp()
  ls.add_snippets('fsharp', {
    s('todo', t('failwith "todo"')),
    s('arm', { t('| '), i(1, 'case'), t(' -> '), i(2, '()') }),
    s('pfn', fmt([[printfn $"{}"]], { i(1, 'msg') })),

    s(
      'letfn',
      fmt(
        [[
        let {} () =
            {}
        ]],
        { i(1, 'func'), i(2, 'failwith "todo"') }
      )
    ),

    s(
      'union',
      fmt(
        [[
        type {} =
            | {}
            | {}
        ]],
        { i(1, 'Union'), i(2, 'A'), i(3, 'B') }
      )
    ),

    s(
      'match',
      fmt(
        [[
        match {} with
        | {} -> {}
        ]],
        { i(1, 'cond'), i(2, 'case'), i(3, '()') }
      )
    ),

    s(
      'mem',
      fmt(
        [[
        member {} {} = 
            {}
        ]],
        { i(1, 'fn'), i(2, '()'), i(3, 'failwith "todo"') }
      )
    ),

    s(
      'smem',
      fmt(
        [[
        static member {} {} = 
            {}
        ]],
        { i(1, 'fn'), i(2, '()'), i(3, 'failwith "todo"') }
      )
    ),

    s('attr', { t('[<'), i(1, ''), t('>]') }),
  })
end

function M.ocaml()
  ls.add_snippets('ocaml', {
    s('doc', {
      t('(*'),
      i(1, ''),
      t('*)'),
    }),

    s('module', {
      t('module '),
      c(1, {
        sn(nil, {
          i(1, 'Module'),
          t({ ' = struct', '\t' }),
          i(2, ' '),
          t({ '', 'end' }),
        }),

        sn(nil, {
          t('type '),
          i(1, 'Module'),
          t({ ' = sig', '\t' }),
          i(2, ' '),
          t({ '', 'end' }),
        }),
      }),
      i(0),
    }),

    s({ trig = 'let', desc = 'Choose from variable, function or module' }, {
      t('let '),

      c(1, {
        sn(nil, {
          i(1, 'name'),
          t(' = '),
          i(2, 'value'),
          t(' in'),
        }, { key = 'var' }),

        sn(nil, {
          i(1, 'func'),
          t(' '),
          i(2, '()'),
          t({ ' =', '\t' }),
          i(3, '()'),
        }, { key = 'function' }),

        sn(nil, {
          t('open '),
          i(1, 'Module'),
          t(' in'),
        }),
      }),
      i(0),
    }),
  })
end

function M.js()
  ls.add_snippets('javascript', {
    s('doc', { t('/** '), i(1, ' '), t(' */') }),
    s(
      'doc',
      fmt(
        [[
      /**
       * {}
       */
      ]],
        { i(1, '') }
      )
    ),
  })

  ls.filetype_extend('javascript', { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' })
end

function M.lua()
  ls.add_snippets('lua', {
    s('doc', { t('---@') }),
  })
end

---Setup snippets for filetypes
---@param fnames string[]
---@param fn fun()
local function setup_snippets(fnames, fn)
  -- call fn immediately if current fn is in filetypes
  -- otherwise lazy load snippets
  if vim.tbl_contains(fnames, vim.bo.filetype) then
    fn()
  else
    vim.api.nvim_create_autocmd('FileType', {
      pattern = fnames,
      callback = fn,
      once = true,
    })
  end
end

---Add all language snippets
function M.add_all_snippets()
  --M.ocaml()
  --M.fsharp()
  --M.js()
  --M.lua()

  setup_snippets({ 'ocaml' }, M.ocaml)
  setup_snippets({ 'fsharp' }, M.fsharp)
  setup_snippets({ 'lua' }, M.lua)
  setup_snippets({ 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }, M.js)
end

return M
