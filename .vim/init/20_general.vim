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

" Enable settings depends on filetype
filetype plugin indent on

" Enable incremental search
set incsearch

" Don't make backup files and swapfile
set nowritebackup
set nobackup
set noswapfile
set noundofile

" Disable ring beep
set vb t_vb=

set whichwrap=b,s,h,l,<,>,[,]

set completeopt=menuone

" Open new panes in the below or right
set splitbelow
set splitright

set clipboard=unnamed

" Expand QuickFix windows automatically
augroup QuickFixCmd
    autocmd!
    autocmd QuickFixCmdPost *grep* cwindow
augroup END
