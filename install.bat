@echo off

if exist %UserProfile%\.vimrc goto PROMPT
else goto COPY


:PROMPT
set /P "AreYouSure=vimrc exists. overrite? (Y/[N])?"
If /I "%AreYouSure%" NEQ "Y" goto END

:COPY
copy .vimrc %UserProfile%
xcopy /s /y vimfiles "%UserProfile%/vimfiles"

:END
