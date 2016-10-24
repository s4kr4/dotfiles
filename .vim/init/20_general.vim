" --------------------------------------------------------------------
"  General Settings
" --------------------------------------------------------------------

augroup mAutoCmd
    autocmd!
augroup END

set encoding=utf-8
set fileencoding=utf-8
scriptencoding utf-8

" Enable using mouse
set mouse=a

" Enable settings depends on filetile
filetype plugin indent on

" Enable incremental search
set incsearch

" Don't make backup files and swapfile
set nowritebackup
set nobackup
set noswapfile

" Disable ring beep
set vb t_vb=

set whichwrap=b,s,h,l,<,>,[,]

set completeopt=menuone
