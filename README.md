# notes_vimscript
My vimrc and set up for notes/todo lists in VIM.

Running the install.bat script after cloning will copy the .vimrc and the necessary syntax files into the User Profile directory.  Which is where gvim (at least in default installation) looks for .vimrc and the vimfiles folder.

# Commands
- F5 - Insert new TODO/Notes Date header
- F2 - Toggle from needs to be done to done or back
- Ctrl-Up - Move the current TODO up
- Ctrl-Down - Move the current TODO down


# Bugs
1. Ctrl-Up and Ctrl-Down don't do exactly what I want.  They should move the TODO until the next indented line up or down, but instead it has some semi-wonky behavior.
