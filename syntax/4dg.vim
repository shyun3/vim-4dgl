" 4DGL syntax file
" See https://resources.4dsystems.com.au/manuals/4dgl/

" See `b:current_syntax-variable`
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

syn match 4dgUserLabel "\v^\s*\zs\I\i*\ze:([^=]|$)"

" Comments
syn match 4dgComment "//.*$"
syn region 4dgComment start="/\*" end="\*/"

syn cluster 4dgDirGroup contains=4dgNumber,4dgComment,4dgChar,4dgString

" Constants
syn region 4dgConstant start="\v^\s*\zs#constant>" skip="\\$" end="$" keepend contains=@4dgDirGroup
syn region 4dgConstant start="\v^\s*\zs#CONST>" end="\v^\s*\zs#END>" keepend contains=@4dgDirGroup

syn keyword 4dgType var

" Characters
syn match 4dgSpecialChar contained "\\[\\abfnrtv']"
syn match 4dgChar "'[^']*'" contains=4dgSpecialChar

" Strings
syn match 4dgSpecialStrChar contained '\\[\\abfnrtv"]'
syn region 4dgString start='"' skip='\v\\\\|\\"' end='"' contains=4dgSpecialStrChar

" Data
syn keyword 4dgDataType contained byte word
syn region 4dgData matchgroup=4dgPreProc start="\v^\s*\zs#DATA>" end="\v^\s*\zs#END>" keepend contains=@4dgDirGroup,4dgDataType

syn keyword 4dgOperator sizeof argcount

" Pre-processor
syn region 4dgPreCondit start="\v^\s*\zs#%(IF|IFNOT)>" skip="\\$" end="$" keepend contains=@4dgDirGroup
syn match 4dgPreConditMatch display "\v^\s*\zs#%(ELSE|ENDIF)>"
syn region 4dgPreProc start="\v^\s*\zs#%(MESSAGE|NOTICE|ERROR|STOP|USE|MODE|STACK)>" skip="\\$" end="$" keepend contains=@4dgDirGroup
syn match 4dgInclude display "\v^\s*\zs#%(inherit|platform)>"

syn keyword 4dgCond if else endif switch endswitch
syn keyword 4dgRepeat while wend repeat until forever for next
syn keyword 4dgKeyword func endfunc gosub endsub
syn keyword 4dgStatement goto break continue return
syn keyword 4dgLabel case default

syn match 4dgFunc "\<\h\w*\ze\_s*("

syn sync minlines=1000

" Define the default highlighting
" Only applies when an item doesn't have highlighting yet
hi def link 4dgNumber Number
hi def link 4dgUserLabel Label
hi def link 4dgComment Comment
hi def link 4dgConstant Macro
hi def link 4dgType Type
hi def link 4dgSpecialChar SpecialChar
hi def link 4dgChar Character
hi def link 4dgSpecialStrChar 4dgSpecialChar
hi def link 4dgString String
hi def link 4dgDataType Type
hi def link 4dgOperator Operator
hi def link 4dgPreCondit PreCondit
hi def link 4dgPreConditMatch 4dgPreCondit
hi def link 4dgPreProc PreProc
hi def link 4dgInclude Include
hi def link 4dgCond Conditional
hi def link 4dgRepeat Repeat
hi def link 4dgKeyword Keyword
hi def link 4dgStatement Statement
hi def link 4dgLabel Label
hi def link 4dgFunc Function

let b:current_syntax = "4dg"

let &cpo = s:cpo_save
unlet s:cpo_save
