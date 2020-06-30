" --------------------------------------------------------------------------------
" My personal defaults.  Just ditch them if you are uninterested
set ai
syntax on
set shiftwidth=2
set tabstop=2
set expandtab
set number
set nowrap
set guifont=Consolas:h11

" --------------------------------------------------------------------------------
" TODO Related

" Insert Time stamp
nnoremap <F5> :3<CR>I<CR><CR><esc>:3<CR><esc>"=strftime("%Y-%m-%d")<CR>PA @ IN->OUT<CR>- 
inoremap <F5> <esc>:3<CR>I<CR><CR><esc>:3<CR><esc>"=strftime("%Y-%m-%d")<CR>PA @ IN->OUT<CR>-

" Toggle Lines from done to not done
function! NotesToggleTodo()
    let cline = getline('.')

    if cline[0] == "+"
        s/+/-/
        return
    endif

   " After the starting line all lines can be indented
   " and the indent todo can have . or -
   try
     let minusMatchAt = matchstr(cline, "-")
     if minusMatchAt == 0
        if cline[0] == "-"
          s/-/+/
          return
        else
          s/-/./
          return
        endif
     endif
   catch /.*/
   endtry

   try
     let minusMatchAt = matchstr(cline, "\.")
     if minusMatchAt == 0
          s/\./-/
     endif
   catch /.*/
   endtry
  
endfunction
nnoremap <F2> :call NotesToggleTodo()<CR>
inoremap <F2> <esc>:call NotesToggleTodo()<CR>

" Move line up and down
function! MoveLineDown()
  " Store off all lines starting here up to the next line that has a character
  " on it, or a blank line
  let lineBlock = []
  let startingLine = line('.')
  let lineCount = line('.') 
  let linesToDel = -1
  let stillLooking = 1

  let cLine = getline('.')
  while stillLooking
      call add(lineBlock, cLine)
      let lineCount += 1
      let linesToDel += 1
      let cLine = getline(lineCount)
      let stillLooking = !(cLine[0] == '.' || cLine[0] == '+' || cLine[0] == '-' || cLine == '')
  endwhile

  " lineCount is the first line that is different
  " find the next line that is different
  let stillLooking = 1
  while stillLooking
      let lineCount += 1
      let cLine = getline(lineCount)
      let stillLooking = !(cLine[0] == '.' || cLine[0] == '+' || cLine[0] == '-' || cLine == '')
  endwhile

  " lineCount is the end of the next todo block
  let lineCount -= 1
  let newStartLine = lineCount - linesToDel
  for line in lineBlock
      call append(lineCount, line)
      let lineCount += 1
  endfor

  " TODO Figure out how to delete a range
  let endingLine = startingLine + linesToDel
  execute startingLine.",".endingLine 'delete _'
  call cursor(newStartLine, 0)

endfunction
nnoremap <C-Down> :call MoveLineDown()<CR>

function! MoveLineUp()
  " Store off all lines starting here up to the next line that has a character
  " on it, or a blank line
  let lineBlock = []
  let startingLine = line('.')
  let lineCount = line('.') 
  let linesToDel = -1
  let stillLooking = 1

  let cLine = getline('.')
  while stillLooking
      call add(lineBlock, cLine)
      let lineCount += 1
      let linesToDel += 1
      let cLine = getline(lineCount)
      let stillLooking = !(cLine[0] == '.' || cLine[0] == '+' || cLine[0] == '-' || cLine == '')
  endwhile

  " TODO Figure out how to delete a range
  let endingLine = startingLine + linesToDel
  execute startingLine.",".endingLine 'delete _'

  " lineCount is the first line that is different
  " find the next line that is different
  let stillLooking = 1
  let lineCount = startingLine - 1
  while stillLooking
      let cLine = getline(lineCount)
      let stillLooking = !(cLine[0] == '.' || cLine[0] == '+' || cLine[0] == '-' || cLine == '')
      let lineCount -= 1
  endwhile

  " lineCount is the end of the next todo block
  let newStartingLine = lineCount + 1
  for line in lineBlock
      call append(lineCount, line)
      let lineCount += 1
  endfor

  call cursor(newStartingLine, 0)

endfunction
nnoremap <C-Up> :call MoveLineUp()<CR>
