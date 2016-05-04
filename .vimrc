" autogroup
augroup mAutoCmd
    autocmd!
augroup END


" ########## Visual Settings ##########

" use 256 colors
set t_Co=256

" display row number and ruler
set number
set ruler

" display cursor line
set cursorline

" display statusline 
set laststatus=2

" statusline settings
set statusline=%F%m%r%h%w%{fugitive#statusline()}%=[TYPE:%Y][FMT:%{&fileformat}][ENC:%{&fileencoding}][LOW:%l/%L]

" highlight corresponding brakets
set showmatch

" wrap line
set wrap

" no break in the middle of words
set linebreak
" set breakindent

" visible whitespace
set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:%,eol:<

" highlight full-width characters
augroup highlightSpace
    autocmd!
    autocmd Colorscheme * hi IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
    autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END


" ########## Edit ##########

filetype plugin indent on
set backspace=start,eol,indent
" set paste
set mouse=a
set incsearch
set wildmenu wildmode=list:full
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set hidden
set switchbuf=useopen
set nowritebackup
set nobackup
set noswapfile


" Other settings

set completeopt=menuone
set vb t_vb=

" Key map

let mapleader='\<Space>'

nnoremap j gj
nnoremap k gk
nnoremap <Space>e :VimFilerExplorer -winwidth=30<CR>

""inoremap <silent> jj <ESC>
inoremap <C-j> <ESC>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>
inoremap " ""<Left>
inoremap ' ''<Left>


" dein.vim

set nocompatible

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

call dein#begin(s:dein_dir)

let s:toml      = $DOTPATH.'/.vim/dein.toml'
let s:lazy_toml = $DOTPATH.'/.vim/dein_lazy.toml'

if dein#load_cache([expand('<sfile>'), s:toml, s:lazy_toml])
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  call dein#save_cache()
endif

call dein#end()

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on
set autoindent

syntax on
colorscheme badwolf
hi Normal ctermbg=none
hi NonText ctermbg=none
hi SpecialKey ctermbg=none
hi CursorColumn cterm=none ctermbg=gray
hi CursorLine cterm=underline ctermfg=none ctermbg=none

set whichwrap=b,s,<,>,[,],h,l


" neocomplete
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


" neosnippet

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

"" submode.vim
"call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
"call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
"call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>-')
"call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>+')
"call submode#map('winsize', 'n', '', '>', '<C-w>>')
"call submode#map('winsize', 'n', '', '<', '<C-w><')
"call submode#map('winsize', 'n', '', '+', '<C-w>-')
"call submode#map('winsize', 'n', '', '-', '<C-w>+')

" vim-coffee-script
au BufRead,BufNewFile,BufReadPre *.coffee set filetype=coffee
" インデント設定
autocmd FileType coffee setlocal sw=2 sts=2 ts=2 et
" オートコンパイル
"保存と同時にコンパイルする
autocmd BufWritePost *.coffee silent make! 
"エラーがあったら別ウィンドウで表示
autocmd QuickFixCmdPost * nested cwindow | redraw! 
" Ctrl-cで右ウィンドウにコンパイル結果を一時表示する
nnoremap <silent> <C-C> :CoffeeCompile vert <CR><C-w>h

