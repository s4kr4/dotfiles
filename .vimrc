
if has('win32') || has('win64') || has('win32unix')
  set runtimepath+=$HOME/.vim
endif

runtime! init/*.vim
runtime! functions.vim

