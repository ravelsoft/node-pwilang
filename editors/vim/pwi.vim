"Vim syntax file
" Language:	Vim 7.2 script
" Filenames:    *.ini, .hgrc, */.hg/hgrc
" Maintainer:	Peter Hosey
" Last Change:	Nov 11, 2008
" Version:	7.2-02

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

runtime! syntax/jinja.vim

syn match   includeRule "^\s*%.*" contains=@NoSpell

syn match   commentRule "^\s*#.*$" contains=@NoSpell

" syn match   codeRule "[^\\]$[ ]*{.*}"ms=s+1
" syn match   codeRule "^$[ ]*{.*}"
"syn region codeRule start=+[^\\]$[ ]*{+ms=s+1 end=+}+ skip=+\\}+ contains=@NoSpell
"syn region codeRule start=+^$[ ]*{+ end=+}+ skip=+\\}+ contains=@NoSpell
"syn match   codeRule "^$[A-Za-z0-9_\.]\+" contains=@NoSpell
"syn match   codeRule "[^\\]$[A-Za-z0-9_\.]\+"ms=s+1 contains=@NoSpell
"syn match   codeRule "^$[A-Za-z0-9_\.]\+(.*)" contains=@NoSpell
"syn match   codeRule "[^\\]$[A-Za-z0-9_\.]\+(.*)"ms=s+1 contains=@NoSpell

syn match  escapedRule '\\.'
"syn match   bigTagRule  '^@/\?[[:alnum:]_-]\+\(\s*\.[[:alnum:]_-]\+\|\s*#[[:alnum:]_-]\+\|\s*[[:alnum:]_-]\+=\"\(.\|\\\"\)*\"\)*' contains=tagRule,classRule,keyRule,idRule,valueRule,@NoSpell
syn match   bigTagRule  '@/\?[[:alnum:]_-]\+\(\s*\.[[:alnum:]_-]\+\|\s*#[[:alnum:]_-]\+\|\s*[[:alnum:]_-]\+=\"\(.\|\\\"\)*\"\|\s*[[:alnum:]_-]\+=\'\(.\|\\\'\)*\'\|\s*[[:alnum:]_-]\+=\(\\ \|[^ \t\n]\)\+\|\s*\\[[:alnum:]_-]\+\)*' contains=tagRule,classRule,keyRule,idRule,valueRule,@NoSpell

"syn match   tagRule     '[^\\]@[a-zA-Z0-9_-]\+'ms=s+1 
"syn match   tagRule     '^@[a-zA-Z0-9_-]\+' 
syn match   tagRule     '@/\?[a-zA-Z0-9_-]\+' contained contains=@NoSpell
syn match   htmlCharRule '&[a-z]\+;' contains=@NoSpell

syn match   idRule  "\#[[:alnum:]_-]\+" contained contains=@NoSpell
syn match   classRule   '\.[[:alnum:]_-]\+' contained contains=@NoSpell
syn match   keyRule     "[[:alnum:]_-]\+="me=e-1 contained contains=@NoSpell
syn match   keyRule     "\\[/[:alnum:]_-]\+" contained contains=@NoSpell
syn region  valueRule  start=+="+ms=s+1 end=+"+ skip=+\\"+ contained contains=@NoSpell,escapedRule,bigTagRule
syn region  valueRule  start=+='+ end=+'+ skip=+\\"+ contained contains=@NoSpell,escapedRule,bigTagRule
syn match   valueRule "=[^\"']\(\\ \|[^ \t\n]\)*"ms=s+1  contained contains=@NoSpell



syn match PwiTitle "^ *@h1 .*$" contains=classRule,keyRule,idRule,valueRule,@NoSpell
syn match PwiSection "^ *@h2 .*$"
syn match PwiSubsection "^ *@h3 .*$"

" Highlighting Settings
" ====================

hi def link includeRule PreProc
hi def link escapedRule Statement
hi def link htmlCharRule Statement

hi def link tagRule Function
hi def link classRule Constant
hi def link idRule Keyword
hi def link valueRule String
hi def link keyRule Identifier
hi def link commentRule Comment

let b:current_syntax = "pwi"

