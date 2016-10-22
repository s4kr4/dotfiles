" autogroup
augroup mAutoCmd
    autocmd!
augroup END

set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8

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

runtime! plugins/*.vim

