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
nnoremap <F5> :1<CR>I<CR><CR><esc>:1<CR><esc>"=strftime("%Y-%m-%d")<CR>PA @ IN->OUT<CR>- 
inoremap <F5> <esc>:1<CR>I<CR><CR><esc>:1<CR><esc>"=strftime("%Y-%m-%d")<CR>PA @ IN->OUT<CR>-

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

" Move all unfinished to a new date
function! MoveUnfinishedToNew()
" From current line down to next date do the following
" If line starts with - then store it
" If line is empty - then store it
" Once done jump to the top, dump the date, dump everything in list
 " Find the first date and then process from there.
  call cursor(0, 0)
  let lineBlock = []
  let stillLooking = 1
  let currentLine = getline(0)
  let lineCount = 0
  let hasStarted = 0

  while !(currentLine[0] =~? '^\d')
      let lineCount += 1
      let currentLine = getline(lineCount)
      let stillLooking = !(currentLine =~? '^\d')
  endwhile

  let stillLooking = 1
 
  while stillLooking
      " Only check the high level for the 
      if (currentLine[0] == '-')
        call add(lineBlock, currentLine)
        let lineCount += 1
        let currentLine = getline(lineCount)
        while (currentLine[0] == '' || currentLine[0] == ' ')
          call add(lineBlock, currentLine)
          let lineCount += 1
          let currentLine = getline(lineCount)
        endwhile
        let lineCount -= 1

        let hasStarted = 1
      endif

      if (currentLine[0] == '' && hasStarted == 1)
        call add(lineBlock, currentLine)
      endif  

      let lineCount += 1
      let currentLine = getline(lineCount)
      let stillLooking = !(currentLine =~? '^\d')
  endwhile

  call cursor(0, 0)
  call append(0, strftime("%Y-%m-%d") . " @ IN->OUT")  

  let lineCount = 1
  for line in lineBlock
      call append(lineCount, line)
      let lineCount += 1
  endfor
endfunction
nnoremap <F6> :1<CR>:call MoveUnfinishedToNew()<CR>
inoremap <F6> <esc>:1<CR>:call MoveUnfinishedToNew()<CR>
