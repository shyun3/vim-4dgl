" 4DGL syntax file
" See https://resources.4dsystems.com.au/manuals/4dgll/

" See `b:current_syntax-variable`
if exists("b:current_syntax")
  finish
endif

" See `use-cpo-save`
let s:cpo_save = &cpo
set cpo&vim

syn case match

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn keyword 4dglCond if else endif switch endswitch
syn keyword 4dglRepeat while wend repeat until forever for next
syn keyword 4dglKeyword func endfunc gosub endsub
syn keyword 4dglStatement goto break continue return
syn keyword 4dglLabel case default
syn keyword 4dglStorageClass private
syn keyword 4dglType var byte word
syn keyword 4dglOperator sizeof argcount

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Strings and characters

" Special characters (those with backslash)
syn match 4dglSpecial display contained "\v\\%(.|$)"

syn region 4dglString start='"' skip='\v\\\\|\\"' end='"' oneline
  \ contains=4dglSpecial,@Spell

syn region 4dglChar start="'" skip="\v\\\\|\\'" end="'" oneline
  \ contains=4dglSpecial

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Flag errors caused by wrong parentheses
syn region 4dglParen transparent start="(" end=")"
  \ contains=TOP,4dglParenError,4dglUserLabel,@Spell

syn match 4dglParenError display ")"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Numbers

" Integer
syn match 4dglNumber "\v<\d+>"

" Hex
syn match 4dglNumber "\v<0x\x+>"

" Binary
syn match 4dglNumber "\v<0b[01]+>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Comments
syn match 4dglComment "//.*$" contains=@Spell

syn region 4dglComment matchgroup=4dglCommentStart start="/\*" end="\*/"
  \ contains=4dglCommentStartError,@Spell extend
syn match 4dglCommentStartError display "/\*"me=e-1 contained

syn match 4dglCommentError display "\*/"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pre-processor

" Single-line directives
syn cluster 4dglDirGroupX contains=4dglUserLabel,4dglFunc
syn region 4dglConstant start="\v^\s*\zs#constant>" end="$" keepend
  \ contains=TOP,@4dglDirGroupX,@Spell
syn region 4dglPreProc
  \ start="\v^\s*\zs#%(MESSAGE|NOTICE|ERROR|USE|MODE|STACK)>" end="$" keepend
  \ contains=TOP,@4dglDirGroupX,@Spell
syn match 4dglPreProc "\v^\s*\zs#STOP>"

" Block directives
syn cluster 4dglBlockDirGroupX
  \ contains=4dglPreProc,4dglPreCondit,4dglInclude,4dglData,4dglConstant
syn region 4dglData matchgroup=4dglPreProc keepend
  \ start="\v^\s*\zs#DATA>" end="\v^\s*\zs#END>"
  \ contains=TOP,@4dglBlockDirGroupX
syn region 4dglConstant start="\v^\s*\zs#CONST>" end="\v^\s*\zs#END>" keepend
  \ contains=TOP,@4dglBlockDirGroupX

" Conditional
syn region 4dglPreCondit start="\v^\s*\zs#%(IF|IFNOT)>" end="$" keepend
  \ contains=4dglComment,4dglChar,4dglString,4dglNumber,4dglCommentError,4dglParenError,4dglParen
syn match 4dglPreCondit display "\v^\s*\zs#%(ELSE|ENDIF)>"

" Includes
" Included strings don't highlight escaped characters differently
syn region 4dglIncluded display contained oneline
  \ start='"' skip='\v\\\\|\\"' end='"'
syn match 4dglInclude display '\v^\s*\zs#%(inherit|platform)>\s*"'he=e-1
  \ contains=4dglIncluded

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User labels

" Don't highlight as label if the `?` of a ternary starts on a previous line
syn region 4dglTernary transparent start="?" end=":"
  \ contains=TOP,4dglUserLabel,@Spell

syn match 4dglUserLabel display "\v%(^|;)\s*\zs\I\i*\ze:%([^=]|$)"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn match 4dglFunc "\<\h\w*\ze\_s*("

syn sync minlines=1000

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Define the default highlighting
" Only applies when an item doesn't have highlighting yet
hi def link 4dglCond Conditional
hi def link 4dglRepeat Repeat
hi def link 4dglKeyword Keyword
hi def link 4dglStatement Statement
hi def link 4dglLabel Label
hi def link 4dglUserLabel Label
hi def link 4dglStorageClass StorageClass
hi def link 4dglType Type
hi def link 4dglOperator Operator
hi def link 4dglChar Character
hi def link 4dglSpecial SpecialChar
hi def link 4dglString String
hi def link 4dglNumber Number
hi def link 4dglError Error
hi def link 4dglParenError 4dglError
hi def link 4dglComment Comment
hi def link 4dglCommentStart 4dglComment
hi def link 4dglCommentStartError 4dglError
hi def link 4dglCommentError 4dglError
hi def link 4dglConstant Macro
hi def link 4dglPreCondit PreCondit
hi def link 4dglPreProc PreProc
hi def link 4dglInclude Include
hi def link 4dglIncluded 4dglString
hi def link 4dglFunc Function

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let b:current_syntax = "4dgl"

let &cpo = s:cpo_save
unlet s:cpo_save
