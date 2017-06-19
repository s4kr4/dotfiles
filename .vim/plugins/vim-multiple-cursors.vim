" --------------------------------------------------------------------
"  terryma/vim-multiple-cursors
" --------------------------------------------------------------------

function! Multiple_cursors_before()
  exe 'NeoCompleteLock'
  echo 'Disabled Neocomplete'
endfunction

function! Multiple_cursors_after()
  exe 'NeoCompleteUnlock'
  echo 'Enabled Neocomplete'
endfunction

