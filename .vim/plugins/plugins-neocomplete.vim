" --------------------------------------------------------------------
" Shougo/neocomplete.vim
" --------------------------------------------------------------------

let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#auto_completion_start_length = 2
let g:neocomplete#enable_underbar_completion = 1
let g:neocomplete#lock_buffer_name_pettern = '\*ku\*'
let g:neocomplete#max_list = 10
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

