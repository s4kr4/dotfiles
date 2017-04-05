" --------------------------------------------------------------------
"  Keymap Settings
" --------------------------------------------------------------------
noremap <C-j> <ESC>
noremap! <C-j> <ESC>

nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> <C-k> <C-e>
nnoremap <silent> <C-j> <C-y>

nnoremap <Space>h <C-w>h
nnoremap <Space>j <C-w>j
nnoremap <Space>k <C-w>k
nnoremap <Space>l <C-w>l

inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>
inoremap " ""<Left>
inoremap ' ''<Left>

nnoremap day <ESC>a<C-r>=strftime("%Y-%m-%d ")<CR><ESC>
nnoremap time <ESC>a<C-r>=strftime("%H:%M:%S ")<CR><ESC>

nnoremap <silent> <S-CR> :<C-u>call append(expand('.'), '')<CR>j

nnoremap <C-w> :w<CR>
nnoremap <C-q> :q<CR>

