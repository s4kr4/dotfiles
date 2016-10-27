" --------------------------------------------------------------------
"  tyru/caw.vim
" --------------------------------------------------------------------

if dein#is_sourced('caw.vim')
  " Enable toggle comment/uncomment using same keymap
  nmap <C-c><C-c> <Plug>(caw:hatpos:toggle)
  vmap <C-c><C-c> <Plug>(caw:hatpos:toggle)
endif

