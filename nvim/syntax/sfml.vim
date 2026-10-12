" Vim syntax file
" Language:  Super Factory Manager Language (SFML)
" Filenames: *.sfm, *.sfml
" Source:    derived from SFML.g4 in TeamDman/SuperFactoryManager
"
" Notes:
"   * SFML keywords are case-insensitive, hence `syn case ignore`.
"   * Comments are `-- ...` to end of line.
"   * Bare identifiers (labels / unqualified resource names) are
"     indistinguishable without a parser, so they are left unhighlighted.
"     Qualified ids such as `minecraft:iron_ingot` or `forge:ores/iron`
"     are highlighted as resources.

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case ignore

" --- Program structure -------------------------------------------------------
syn keyword sfmlStructure name every pulse redstone

" `if` / `do` blocks (both closed by `end`); these give folding + nesting.
" `else if` is matched first so its `if` does not open a nested block.
syn keyword sfmlConditional then
syn match   sfmlConditional /\<else\>/
syn match   sfmlConditional /\<else\_s\+if\>/
syn region  sfmlIfBlock matchgroup=sfmlConditional start=/\<if\>/ end=/\<end\>/ transparent fold contains=TOP
syn region  sfmlDoBlock matchgroup=sfmlStructure   start=/\<do\>/ end=/\<end\>/ transparent fold contains=TOP

" --- IO statements -----------------------------------------------------------
syn keyword sfmlIO       input output from to forget
syn keyword sfmlModifier each except retain slot slots empty in where side

" --- Resource filters / boolean logic ----------------------------------------
syn keyword sfmlOperator and or not has overall some one lone with without tag
syn keyword sfmlOperator gt lt eq le ge plus
syn keyword sfmlBoolean  true false

" --- Round robin, sides, time units ------------------------------------------
syn keyword sfmlRoundRobin round robin by label block
syn keyword sfmlSide       top bottom north east south west left right front back null
syn keyword sfmlTime       tick ticks second seconds global
syn match   sfmlTime       /\<g\>/

" --- Numbers -----------------------------------------------------------------
syn match sfmlNumber /\<\d\+\>/
syn match sfmlNumber /\<\d\+g\>/

" --- Symbols -----------------------------------------------------------------
syn match sfmlOperator  /<=\|>=\|[<>=+]/
syn match sfmlDelimiter /[,:/()#-]/

" --- Resource ids ------------------------------------------------------------
" tag / hashtag matchers without a namespace, e.g.  with tag logs/oak, with #logs
syn match sfmlResource /\%(#\|\<tag\s\+\)\@<=[A-Za-z_*][A-Za-z0-9_*]*\%(\/[A-Za-z0-9_*]\+\)*/
" namespaced ids: a:b, a:b:c, a::, a:::  (item/fluid/gas/fe plus tag paths)
syn match sfmlResource /\%([A-Za-z0-9_*]\)\@<![A-Za-z_*][A-Za-z0-9_*]*\%(:[A-Za-z0-9_*]*\)\{1,3}\%(\/[A-Za-z0-9_*]\+\)*/

" --- Strings and comments (defined last so they win) -------------------------
syn region sfmlString start=/"/ skip=/\\"/ end=/"/ contains=sfmlEscape
syn match  sfmlEscape /\\"/ contained

syn keyword sfmlTodo TODO FIXME XXX NOTE contained
syn match   sfmlComment /--.*$/ contains=sfmlTodo,@Spell

" --- Highlight links ---------------------------------------------------------
hi def link sfmlStructure   Statement
hi def link sfmlConditional Conditional
hi def link sfmlIO          Keyword
hi def link sfmlModifier    StorageClass
hi def link sfmlOperator    Operator
hi def link sfmlBoolean     Boolean
hi def link sfmlRoundRobin  Keyword
hi def link sfmlSide        Constant
hi def link sfmlTime        Type
hi def link sfmlNumber      Number
hi def link sfmlDelimiter   Delimiter
hi def link sfmlResource    Identifier
hi def link sfmlString      String
hi def link sfmlEscape      SpecialChar
hi def link sfmlComment     Comment
hi def link sfmlTodo        Todo

let b:current_syntax = "sfml"

let &cpo = s:cpo_save
unlet s:cpo_save
