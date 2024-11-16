" See `30.3`
if exists("b:did_indent")
   finish
endif

let b:did_indent = 1

" See `use-cpo-save`
let s:cpo_save = &cpo
set cpo&vim

setlocal indentexpr=s:CalcIndent()
setlocal autoindent

" Remove indenting on braces, which were set by default
setlocal indentkeys-=0{,0}

" Reindent on block end keywords (`else` is accounted for by default)
setlocal indentkeys+=0=endif,0=wend,0=until,0=forever,0=next,0=endswitch,0=endfunc

" See `undo_indent`
let b:undo_indent = "setlocal autoindent< indentkeys< indentexpr<"

func s:CalcIndent()
  let prev_ignorecase = &ignorecase
  try
    let &ignorecase = 0
    return s:CalcIndentImpl()
  finally
    let &ignorecase = prev_ignorecase
  endtry
endfunc

func s:CalcIndentImpl()
  " Find a non-blank line above the current line
  let prev_lnum = prevnonblank(v:lnum - 1)

  " Check for start of file
  if prev_lnum == 0
    return 0
  endif

  let IsPosNotComment = {lnum, idx -> synIDattr(synID(lnum, idx+1, 1), "name") !~ "Comment$"}

  " Check if line starts with `#`
  let curr_line = getline(v:lnum)
  let idx = match(curr_line, '^\s*#')
  if idx != -1 && IsPosNotComment(v:lnum, idx)
    return 0
  endif

  " Check for user label
  let idx = match(curr_line, '^\s*\I\i*:')
  if idx != -1 && IsPosNotComment(v:lnum, idx)
    return 0
  endif

  " Add shiftwidth after lines that start a block
  let indent = indent(prev_lnum)
  let prev_line = getline(prev_lnum)
  let idx = match(prev_line, '\v^\s*%(#CONST|#DATA|else|switch|func)>')
  if idx != -1
    if IsPosNotComment(prev_lnum, idx)
      let indent += shiftwidth()
    endif
  else
    let idx = match(prev_line, '\v^\s*%(if|while|repeat|for)>')
    if idx != -1
      " Account for single line
      if IsPosNotComment(prev_lnum, idx) && prev_line !~ '\v;\s*(//.*)?$'
        let indent += shiftwidth()
      endif
    endif
  endif

  " Subtract shiftwidth on block end, requires 'indentkeys'
  let idx = match(curr_line, '^\v\s*%(#END|else|endif|wend|until|forever|next|endswitch|endfunc)>')
  if idx != -1 && IsPosNotComment(v:lnum, idx)
      let indent -= shiftwidth()
  endif

  return indent
endfunc

let &cpo = s:cpo_save
unlet s:cpo_save
