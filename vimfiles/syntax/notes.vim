syntax match Date /[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] @ .*$/
highlight Date ctermfg=red cterm=underline guifg=red gui=underline

syntax match IndentedNotDoneLine /- .*$/
highlight IndentedNotDoneLine ctermfg=lightblue guifg=lightblue

syntax match NotDoneLine /^- .*$/
highlight NotDoneLine ctermfg=blue guifg=blue

syntax match DoneLine /+ .*$/
highlight DoneLine ctermfg=darkgreen guifg=darkgreen

syntax match DotLine /\. .*$/
highlight DotLine ctermfg=lightgray guifg=lightgray

syntax match QuestionLine /?.*$/
highlight QuestionLine ctermfg=Brown guifg=Brown
