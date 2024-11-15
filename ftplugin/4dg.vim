" 4DGL filetype plugin file

" See `ftplugin`
if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1

" See `use-cpo-save`
let s:cpo_save = &cpo
set cpo&vim

" Don't auto-wrap text for non-comments
setlocal formatoptions-=t

" Break comment lines, insert comment leader on new lines, allow formatting of
" comments, don't break long non-comment lines
setlocal formatoptions+=croql

setlocal comments=://
setlocal commentstring=//\ %s

let &l:define = '^\s*#constant'
let &l:include = '^\s*#inherit'

" See `undo_ftplugin`
let b:undo_ftplugin = "setlocal fo< com< cms< def< inc<"

" See `matchit`
if !exists("b:match_words")
  let b:match_words =
    \ '^\s*#\%(IF\|IFNOT\)\>:^\s*#ELSE\>:^\s*#ENDIF\>,' ..
    \ '^\s*#\%(CONST\|DATA\)\>:^\s*#END\>,' ..
    \ '\<if\>:\<else\>:\<endif\>'

  let b:undo_ftplugin ..= " | unlet! b:match_words"
endif

let &cpo = s:cpo_save
unlet s:cpo_save
