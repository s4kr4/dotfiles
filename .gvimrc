" --------------------------------------------------------------------
"  .vimrc for GVim
" --------------------------------------------------------------------

if has("mac")
	set transparency=15
elseif has("win64") || has("win32unix") || has("win32")
	autocmd GUIEnter * set transparency=230
endif

set columns=110
set lines=35

syntax enable
colorscheme tender
hi CursorLine gui=underline guifg=NONE guibg=NONE

set guifont=Ricty:h10:cSHIFTJIS:qDRAFT,Migu_1M:h10:cSHIFTJIS:qDRAFT
