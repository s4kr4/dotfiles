
if has('win32') || has('win64') || has('win32unix')
  set runtimepath+=$HOME/.vim
  set runtimepath+=$HOME/.vim/after
endif

runtime! init/*.vim
runtime! functions.vim

