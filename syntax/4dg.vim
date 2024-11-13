" 4DGL syntax file
" See https://resources.4dsystems.com.au/manuals/4dgl/

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Integer number
syn match 4dgNumber "\<\d\+\>"

" Hex number
syn match 4dgNumber "\<0x\x\+\>"

" Binary number
syn match 4dgNumber "\<0b[01]\+\>"

syn match 4dgUserLabel "^\s*\zs\I\i*\s*:$"
syn match 4dgComment "//.*$"

syn keyword 4dgStatement goto break continue return
syn keyword 4dgLabel case default

" Define the default highlighting.
" Only when an item doesn't have highlighting yet
hi def link 4dgNumber Number
hi def link 4dgUserLabel Label
hi def link 4dgComment Comment
hi def link 4dgStatement Statement
hi def link 4dgLabel Label

let b:current_syntax = "4dg"

let &cpo = s:cpo_save
unlet s:cpo_save
