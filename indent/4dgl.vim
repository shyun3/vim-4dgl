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

" Remove indenting on braces, which were set by default. Also, remove indenting
" on `:` since it seems to go by C rules (recall that 4DGL doesn't use braces).
setlocal indentkeys-=0{
setlocal indentkeys-=0}
setlocal indentkeys-=:

" Reindent on block end keywords (`else` is accounted for by default). Also,
" reindent on any `:` for labels.
setlocal indentkeys+=<:>,0=endif,0=wend,0=until,0=forever,0=next,0=endswitch,0=endfunc

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

  let IsPosComment = {lnum, idx -> synIDattr(synID(lnum, idx+1, 1), "name") =~ "Comment$"}

  " Check if line starts with `*` inside a block comment
  let curr_line = getline(v:lnum)
  let idx = match(curr_line, '^\s*\*')
  if idx != -1 && IsPosComment(v:lnum, idx)
    return cindent(v:lnum)
  endif

  " Check if line starts with `#`
  let idx = match(curr_line, '^\s*#')
  if idx != -1 && !IsPosComment(v:lnum, idx)
    return 0
  endif

  " Check for user label (exclude `default`)
  let matches = matchlist(curr_line, '\v^\s*(\I\i*):')
  if len(matches) > 1 && !IsPosComment(v:lnum, 0) && matches[1] != "default"
    return 0
  endif

  " Add shiftwidth after lines that start a block
  let curr_indent = indent(prev_lnum)
  let prev_line = getline(prev_lnum)
  let idx = match(prev_line, '\v^\s*%(#CONST|#DATA|else|switch|func)>')
  if idx != -1
    if !IsPosComment(prev_lnum, idx)
      let curr_indent += shiftwidth()
    endif
  else
    let idx = match(prev_line, '\v^\s*%(if|while|repeat|for)>')
    if idx != -1
      " Account for single line
      if !IsPosComment(prev_lnum, idx)
        let idx = match(prev_line, '\v;\s*%(/\*.*|//.*)?$')
        if idx == -1 || IsPosComment(prev_lnum, idx)
          let curr_indent += shiftwidth()
        endif
      endif
    else
      " Check if previous line is a label
      let idx = match(prev_line, '\v^\s*%(case\s+\i+|\I\i*):')
      if idx != -1 && !IsPosComment(prev_lnum, idx)
        let curr_indent += shiftwidth()
      endif
    endif
  endif

  " Subtract shiftwidth on block end, requires 'indentkeys'
  let idx = match(curr_line, '\v^\s*%(#END|else|endif|wend|until|forever|next|endswitch|endfunc)>')
  if idx != -1
    if !IsPosComment(v:lnum, idx)
      let curr_indent -= shiftwidth()
    endif
  else
    " Check if current line is switch case/default
    let idx = match(curr_line, '\v^\s*%(case\s+\i+|default):')
    if idx != -1 && !IsPosComment(v:lnum, idx)
      " Search backwards for a switch start or case
      let lnum = v:lnum
      let line_limit = max([lnum - 100, 0])   " Only search a close vicinity
      while lnum > line_limit
        let lnum = prevnonblank(lnum-1)
        let line = getline(lnum)
        let idx = match(line, '\v^\s*\zs%(case\s+\i+:|default:|switch>)')
        if idx != -1 && !IsPosComment(lnum, idx)
          break
        endif
      endwhile

      " If search succeeded, indent switch start or match label indent
      if lnum > line_limit
        let curr_indent = indent(lnum) + (line[idx] == 's' ? shiftwidth() : 0)
      endif
    endif
  endif

  return curr_indent
endfunc

let &cpo = s:cpo_save
unlet s:cpo_save
