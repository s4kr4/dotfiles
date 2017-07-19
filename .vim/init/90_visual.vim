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
set statusline=%F%m%r%h%w%{fugitive#statusline()}%=[TYPE:%Y][FMT:%{&fileformat}][ENC:%{&fileencoding}][LINE:%l/%L]

" Enable syntax highlight
syntax enable

" highlight ideographic spaces
augroup highlightSpace
  autocmd!
  autocmd Colorscheme * hi IdeographicSpace term=underline ctermbg=DarkRed guibg=DarkRed
  autocmd VimEnter,WinEnter * match IdeographicSpace /　\|\s\+$/
augroup END

colorscheme badwolf

" Display cursorline
highlight CursorLine cterm=underline ctermfg=none ctermbg=none

" Transparent
highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight SpecialKey ctermbg=none
highlight EndOfBuffer ctermbg=none
highlight LineNr ctermfg=none ctermbg=none

if has('gui')
  " Disable toolbar
  set guioptions-=T

  " Disable scroll bars
  set guioptions-=r
  set guioptions-=R
  set guioptions-=l
  set guioptions-=L
  set guioptions-=b
endif

