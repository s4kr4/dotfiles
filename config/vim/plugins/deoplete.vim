" --------------------------------------------------------------------
"  Shougo/deoplete.nvim
" --------------------------------------------------------------------

" Use neocomplete
let g:deoplete#enable_at_startup = 1

call deoplete#custom#option({
\ 'max_list': 30,
\ 'num_processes': 0,
\ 'skip_multibyte': v:true,
\ })
