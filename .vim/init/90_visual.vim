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
set statusline=%F%m%r%h%w%{fugitive#statusline()}%=[TYPE:%Y][FMT:%{&fileformat}][ENC:%{&fileencoding}][LOW:%l/%L]

" use 256 colors
set t_Co=256

" Enable syntax highlight
syntax on

" highlight ideographic spaces
augroup highlightSpace
    autocmd!
    autocmd Colorscheme * hi IdeographicSpace term=underline ctermbg=DarkRed guibg=DarkRed
    autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END

colorscheme badwolf
"hi Normal ctermbg=none
"hi NonText ctermbg=none
hi CursorLine cterm=underline ctermfg=none ctermbg=none

