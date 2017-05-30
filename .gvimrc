" --------------------------------------------------------------------
"  .vimrc for GVim
" --------------------------------------------------------------------

autocmd GUIEnter * set transparency=230

set columns=110
set lines=35

syntax on
colorscheme badwolf
hi CursorLine gui=underline guifg=NONE guibg=NONE

set noundofile

autocmd FileType markdown hi! def link markdownItalic Normal

set guifont=Migu_1M:h10:cSHIFTJIS:qDRAFT

