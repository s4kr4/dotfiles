" --------------------------------------------------------------------
" Visual Settings
" --------------------------------------------------------------------

" display row number
set number

" display cursor line
set cursorline

" visible whitespace
set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:%,eol:<

" display statusline
set laststatus=2
" set statusline=%F%m%r%h%w%{fugitive#statusline()}%=[TYPE:%Y][FMT:%{&fileformat}][ENC:%{&fileencoding}][LINE:%l/%L]

" Enable syntax highlight
syntax enable

" Highlight search words
set hlsearch

" Scroll offset
set scrolloff=5

" highlight ideographic spaces
" augroup highlightSpace
"   autocmd!
"   autocmd Colorscheme * hi IdeographicSpace term=underline ctermbg=DarkRed guibg=DarkRed
"   autocmd VimEnter,WinEnter * match IdeographicSpace /　\|\s\+$/
" augroup END

colorscheme Tomorrow-Night-Bright

" Display cursorline
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

" Transparent
" highlight Normal ctermbg=NONE guibg=NONE
" highlight NonText ctermbg=NONE guibg=NONE
" highlight SpecialKey ctermbg=NONE guibg=NONE
" highlight EndOfBuffer ctermbg=NONE guibg=NONE
" highlight LineNr ctermfg=NONE ctermbg=NONE

" " Comment
" highlight Comment ctermfg=79
"
" " Selection
" highlight Visual ctermbg=26
"
" " vimdiff
" highlight DiffAdd ctermfg=15 ctermbg=22
" highlight DiffDelete ctermfg=52 ctermbg=52
" highlight DiffChange ctermfg=15 ctermbg=17
" highlight DiffText ctermfg=15 ctermbg=27

if has('gui')
  " Invalidate toolbar
  set guioptions-=T

  " Invalidate menu bar
  set guioptions-=m

  " Invalidate scroll bars
  set guioptions-=r
  set guioptions-=R
  set guioptions-=l
  set guioptions-=L
  set guioptions-=b
endif

