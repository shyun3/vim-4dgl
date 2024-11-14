" 4DGL syntax file
" See https://resources.4dsystems.com.au/manuals/4dgl/

" Check if syntax file was already loaded, see `b:current_syntax-variable`
if exists("b:current_syntax")
  finish
endif

" See `use-cpo-save`
let s:cpo_save = &cpo
set cpo&vim

" Integer number
syn match 4dgNumber "\v<\d+>"

" Hex number
syn match 4dgNumber "\v<0x\x+>"

" Binary number
syn match 4dgNumber "\v<0b[01]+>"

syn match 4dgUserLabel "^\s*\zs\I\i*\s*:$"

" Comments
syn match 4dgComment "//.*$"
syn region 4dgComment start="/\*" end="\*/"

" Constants
syn match 4dgSub "\v%(^|\s)\zs\$" contained
syn cluster 4dgConstGroup contains=4dgNumber,4dgComment,4dgSub
syn region 4dgConstant start="\v^\s*\zs#constant>" skip="\\$" end="$" keepend contains=@4dgConstGroup
syn region 4dgConstant start="\v^\s*\zs#CONST>" end="\v^\s*\zs#END>" keepend contains=@4dgConstGroup

syn keyword 4dgType var

syn keyword 4dgStatement goto break continue return
syn keyword 4dgLabel case default

" Define the default highlighting
" Only applies when an item doesn't have highlighting yet
hi def link 4dgNumber Number
hi def link 4dgUserLabel Label
hi def link 4dgComment Comment
hi def link 4dgSub Operator
hi def link 4dgConstant Macro
hi def link 4dgType Type
hi def link 4dgStatement Statement
hi def link 4dgLabel Label

let b:current_syntax = "4dg"

let &cpo = s:cpo_save
unlet s:cpo_save
