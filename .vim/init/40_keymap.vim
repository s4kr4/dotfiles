" --------------------------------------------------------------------
"  Keymap Settings
" --------------------------------------------------------------------

let mapleader = "\<space>"

noremap <C-j> <ESC>
noremap! <C-j> <ESC>

nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> <C-j> <C-e>
nnoremap <silent> <C-k> <C-y>

noremap <silent> <C-a> ^
noremap <silent> <C-e> $

vnoremap G G$

nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>
inoremap "" ""<Left>
inoremap '' ''<Left>

nnoremap day <ESC>a<C-r>=strftime("%Y-%m-%d ")<CR><ESC>
nnoremap time <ESC>a<C-r>=strftime("%H:%M:%S ")<CR><ESC>

nnoremap <C-q> :q<CR>

nnoremap <leader>e :call FzyCommand("find . -type f", ":e")<CR>
nnoremap <leader>v :call FzyCommand("find . -type f", ":vs")<CR>
nnoremap <leader>s :call FzyCommand("find . -type f", ":sp")<CR>

if has("gui_running")
	nnoremap <silent> <S-CR> :<C-u>call append(expand('.'), '')<CR>j
endif

if has("mac")
	nnoremap ; :
	nnoremap : ;
endif

