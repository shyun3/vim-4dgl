" 4DGL syntax file
" See https://resources.4dsystems.com.au/manuals/4dgll/

" See `b:current_syntax-variable`
if exists("b:current_syntax")
  finish
endif

" See `use-cpo-save`
let s:cpo_save = &cpo
set cpo&vim

syn keyword 4dglCond if else endif switch endswitch
syn keyword 4dglRepeat while wend repeat until forever for next
syn keyword 4dglKeyword func endfunc gosub endsub
syn keyword 4dglStatement goto break continue return
syn keyword 4dglLabel case default

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Strings and characters

" Special characters (those with backslash)
syn match 4dglSpecial display contained "\v\\%(.|$)"

syn region 4dglString start='"' skip='\v\\\\|\\"' end='"' contains=4dglSpecial,@Spell extend
syn region 4dglChar start="'" skip="\v\\\\|\\'" end="'" contains=4dglSpecial extend

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Integer number
syn match 4dglNumber "\v<\d+>"

" Hex number
syn match 4dglNumber "\v<0x\x+>"

" Binary number
syn match 4dglNumber "\v<0b[01]+>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Comments
syn match 4dglComment "//.*$" contains=@Spell

syn region 4dglComment matchgroup=4dglCommentStart start="/\*" end="\*/" contains=4dglCommentStartError,@Spell extend
syn match 4dglCommentStartError display "/\*"me=e-1 contained

syn match 4dglCommentError display "\*/"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn keyword 4dglType var
syn keyword 4dglOperator sizeof argcount

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pre-processor

syn cluster 4dglDirGroup contains=4dglNumber,4dglComment,4dglChar,4dglString,4dglCommentError

" Constants
syn region 4dglConstant start="\v^\s*\zs#constant>" end="$" keepend contains=@4dglDirGroup
syn region 4dglConstant start="\v^\s*\zs#CONST>" end="\v^\s*\zs#END>" keepend contains=@4dglDirGroup

" Data
syn keyword 4dglDataType contained byte word
syn region 4dglData matchgroup=4dglPreProc start="\v^\s*\zs#DATA>" end="\v^\s*\zs#END>" keepend contains=@4dglDirGroup,4dglDataType

syn region 4dglPreCondit start="\v^\s*\zs#%(IF|IFNOT)>" end="$" keepend contains=@4dglDirGroup
syn match 4dglPreConditMatch display "\v^\s*\zs#%(ELSE|ENDIF)>"
syn region 4dglPreProc start="\v^\s*\zs#%(MESSAGE|NOTICE|ERROR|STOP|USE|MODE|STACK)>" end="$" keepend contains=@4dglDirGroup
syn match 4dglInclude display "\v^\s*\zs#%(inherit|platform)>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User labels
syn cluster 4dglLabelGroup contains=4dglUserLabel

syn match 4dglUserCont display "\v^\s*\zs\I\i*:$" contains=@4dglLabelGroup
syn match 4dglUserCont display "\v;\s*\zs\I\i*:$" contains=@4dglLabelGroup

" Avoid matching `:=` by requiring that the next character is not `=`
syn match 4dglUserCont display "\v^\s*\zs\I\i*:[^=]"me=e-1 contains=@4dglLabelGroup
syn match 4dglUserCont display "\v;\s*\zs\I\i*:[^=]"me=e-1 contains=@4dglLabelGroup

syn match 4dglUserLabel display "\I\i*" contained

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn match 4dglFunc "\<\h\w*\ze\_s*("

syn sync minlines=1000

" Define the default highlighting
" Only applies when an item doesn't have highlighting yet
hi def link 4dglNumber Number
hi def link 4dglUserLabel Label
hi def link 4dglComment Comment
hi def link 4dglCommentStart 4dglComment
hi def link 4dglCommentStartError 4dglError
hi def link 4dglCommentError 4dglError
hi def link 4dglConstant Macro
hi def link 4dglType Type
hi def link 4dglChar Character
hi def link 4dglString String
hi def link 4dglDataType Type
hi def link 4dglOperator Operator
hi def link 4dglPreCondit PreCondit
hi def link 4dglPreConditMatch 4dglPreCondit
hi def link 4dglPreProc PreProc
hi def link 4dglInclude Include
hi def link 4dglCond Conditional
hi def link 4dglRepeat Repeat
hi def link 4dglKeyword Keyword
hi def link 4dglStatement Statement
hi def link 4dglLabel Label
hi def link 4dglFunc Function
hi def link 4dglSpecial SpecialChar
hi def link 4dglError Error

let b:current_syntax = "4dgl"

let &cpo = s:cpo_save
unlet s:cpo_save
