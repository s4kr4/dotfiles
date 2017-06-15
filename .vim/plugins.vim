" --------------------------------------------------------------------
"  sjl/badwolf
" --------------------------------------------------------------------

" Determines whether the line number, sign column, and fold column are
" rendered darker than the normal background, or the same.
let g:badwolf_darkgutter = 0

" Determines how light to render the background of the tab line (the line at
" the top of the screen containing the various tabs (only in console mode)).
let g:badwolf_tabline = 1

" Determines whether text inside a tags in HTML files will be underlined.
let g:badwolf_html_link_underline = 1

" Determines whether CSS properties should be highlighted.
let g:badwolf_css_props_highlight = 1


" --------------------------------------------------------------------
"  tyru/caw.vim
" --------------------------------------------------------------------

" Enable toggle comment/uncomment using same keymap
nmap <C-c><C-c> <Plug>(caw:hatpos:toggle)
vmap <C-c><C-c> <Plug>(caw:hatpos:toggle)


" --------------------------------------------------------------------
" Shougo/neocomplete.vim
" --------------------------------------------------------------------

" Use neocomplete
let g:neocomplete#enable_at_startup = 1
" Use smartcase
let g:neocomplete#enable_smart_case = 1
" Start completion with 2 chars
let g:neocomplete#auto_completion_start_length = 2
" Not ignore underbars
let g:neocomplete#enable_underbar_completion = 1
" Number of completion list
let g:neocomplete#max_list = 30

if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
" Ignore Japanese
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Use <TAB> to move list
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Enable omni completion.
augroup SetOmniCompletionSetting
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
  autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup END

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif


" --------------------------------------------------------------------
" Shougo/neosnippet
" --------------------------------------------------------------------

" Plugin key-mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif


" --------------------------------------------------------------------
" kana/vim-submode
" --------------------------------------------------------------------

let g:submode_timeoutlen = 500

call submode#enter_with('winsize', 'n', 's', '<Space>>', '<C-w>>')
call submode#enter_with('winsize', 'n', 's', '<Space><', '<C-w><')
call submode#enter_with('winsize', 'n', 's', '<Space>+', '<C-w>-')
call submode#enter_with('winsize', 'n', 's', '<Space>-', '<C-w>+')

call submode#map('winsize', 'n', 's', '>', '<C-w>>')
call submode#map('winsize', 'n', 's', '<', '<C-w><')
call submode#map('winsize', 'n', 's', '+', '<C-w>-')
call submode#map('winsize', 'n', 's', '-', '<C-w>+')

call submode#enter_with('winmove', 'n', 's', '<Space>h', '<C-w>h')
call submode#enter_with('winmove', 'n', 's', '<Space>j', '<C-w>j')
call submode#enter_with('winmove', 'n', 's', '<Space>k', '<C-w>k')
call submode#enter_with('winmove', 'n', 's', '<Space>l', '<C-w>l')

call submode#map('winmove', 'n', 's', 'h', '<C-w>h')
call submode#map('winmove', 'n', 's', 'j', '<C-w>j')
call submode#map('winmove', 'n', 's', 'k', '<C-w>k')
call submode#map('winmove', 'n', 's', 'l', '<C-w>l')


" --------------------------------------------------------------------
" Shougo/unite.vim
" --------------------------------------------------------------------

call unite#custom#profile('default', 'context', {
\  'start_insert': 1,
\  'ignorecase': 1,
\  'smartcase': 1,
\  'direction': 'belowright'
\})

" grep search
nnoremap <silent> ,g :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
" grep search in specified directory
nnoremap <silent> ,dg  :<C-u>Unite grep -buffer-name=search-buffer<CR>
" grep search with a word on cursor
nnoremap <silent> ,wg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W><CR>
" grep resume
nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>

" open other files in the split window
au FileType unite nnoremap <silent> <buffer> <expr> <CR> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <CR> unite#do_action('split')

" search using ag
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

nnoremap <silent> ,o :<C-u>Unite -no-quit -vertical -winwidth=50 outline<CR>


" --------------------------------------------------------------------
"  vim-javascript
" --------------------------------------------------------------------

let g:javascript_plugin_flow = 1


" --------------------------------------------------------------------
"  elzr/vim-json
" --------------------------------------------------------------------

let g:vim_json_syntax_conceal = 0


" --------------------------------------------------------------------
"  mxw/vim-jsx
" --------------------------------------------------------------------

let g:jsx_ext_required = 0


" --------------------------------------------------------------------
"  MaxMEllon/vim-jsx-pretty
" --------------------------------------------------------------------

let g:vim_jsx_pretty_enable_jsx_highlight = 1

let g:vim_jsx_pretty_colorful_config = 1


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


" --------------------------------------------------------------------
"  thinca/vim-splash
" --------------------------------------------------------------------

let g:splash#path = $HOME."/.vim/splash/helloworld.txt"

