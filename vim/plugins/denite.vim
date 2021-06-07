" --------------------------------------------------------------------
"  Shougo/denite.nvim
" --------------------------------------------------------------------

let mapleader = "\<space>"
nnoremap <silent> <leader>e :<C-u>Denite file/rec<CR>
nnoremap <silent> <leader>g :<C-u>Denite grep -auto-preview<CR>
nnoremap <silent> <leader>G :<C-u>DeniteCursorWord grep -auto-preview<CR>

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
    nnoremap <silent><buffer><expr> <C-S> denite#do_map('do_action', 'split')
    nnoremap <silent><buffer><expr> <C-V> denite#do_map('do_action', 'vsplit')
    nnoremap <silent><buffer><expr> i denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Esc> denite#do_map('quit')
    nnoremap <silent><buffer><expr> q denite#do_map('quit')
	nnoremap <silent><buffer><expr> f denite#do_map('toggle_select')
endfunction

call denite#custom#filter('matcher/ignore_globs', 'ignore_globs', [
        \ '.git/',
        \ '.svn/',
        \ 'node_modules/',
        \ '*.log'
    \ ])

if executable('rg')
    call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
    call denite#custom#var('grep', {
        \ 'command': ['rg', '--threads', '1'],
        \ 'default_opts': ['-i', '--vimgrep', '--no-heading'],
        \ 'recursive_opts': [],
        \ 'pattern_opt': ['--regexp'],
        \ 'separator': ['--'],
        \ 'final_opts': [],
        \ })
endif
