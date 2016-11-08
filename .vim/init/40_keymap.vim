" --------------------------------------------------------------------
"  Keymap Settings
" --------------------------------------------------------------------
noremap <C-j> <ESC>
noremap! <C-j> <ESC>

nnoremap j gj
nnoremap k gk

nnoremap <Space>h <C-w>h
nnoremap <Space>j <C-w>j
nnoremap <Space>k <C-w>k
nnoremap <Space>l <C-w>l

inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>
inoremap " ""<Left>
inoremap ' ''<Left>

nnoremap day <ESC>a<C-r>=strftime("%Y-%m-%d ")<CR>
nnoremap time <ESC>a<C-r>=strftime("%H:%M:%S ")<CR>

