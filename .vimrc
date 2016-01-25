" autogroup
augroup mAutoCmd
	autocmd!
augroup END


" Visual Settings

colorscheme molokai
syntax on
set t_Co=256
let g:hybrid_original = 1
let g:rehash256 = 1
set number
set cursorline
set ruler
set laststatus=2
set statusline=%F%m%r%h%w%=[TYPE:%Y][FMT:%{&fileformat}][ENC:%{&fileencoding}][LOW:%l/%L]
set showmatch
set wrap
set linebreak
" set breakindent
set list
set listchars=tab:>.,trail:-,extends:>,precedes:<,nbsp:%,eol:↲

highlight CursorColumn cterm=none ctermbg=gray
highlight CursorLine cterm=underline ctermbg=none
highlight Normal ctermbg=none


" Edit

filetype plugin indent on
set backspace=start,eol,indent
" set paste
set mouse=a
set incsearch
set wildmenu wildmode=list:full
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

inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>
inoremap " ""<Left>
inoremap ' ''<Left>


" NeoBundle settings

set nocompatible
filetype plugin indent off

if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim/
	call neobundle#begin(expand('~/.vim/bundle/'))
endif

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'sudo.vim'
NeoBundle 'Shougo/unite.vim'

NeoBundle 'Shougo/vimfiler'
let g:vimfiler_as_default_explorer=1
autocmd mAutoCmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif

NeoBundle 'Shougo/neocomplete'

NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'kana/vim-submode'

call neobundle#end()
NeoBundleCheck

filetype plugin indent on
set autoindent

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

" submode.vim
call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>-')
call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>+')
call submode#map('winsize', 'n', '', '>', '<C-w>>')
call submode#map('winsize', 'n', '', '<', '<C-w><')
call submode#map('winsize', 'n', '', '+', '<C-w>-')
call submode#map('winsize', 'n', '', '-', '<C-w>+')


