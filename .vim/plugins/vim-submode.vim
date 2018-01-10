" --------------------------------------------------------------------
" kana/vim-submode
" --------------------------------------------------------------------

let g:submode_timeoutlen = 300

call submode#enter_with('winsize', 'n', 's', '<Space>>', '<C-w>>')
call submode#enter_with('winsize', 'n', 's', '<Space><', '<C-w><')
call submode#enter_with('winsize', 'n', 's', '<Space>+', '<C-w>-')
call submode#enter_with('winsize', 'n', 's', '<Space>-', '<C-w>+')

call submode#map('winsize', 'n', 's', '>', '<C-w>>')
call submode#map('winsize', 'n', 's', '<', '<C-w><')
call submode#map('winsize', 'n', 's', '+', '<C-w>-')
call submode#map('winsize', 'n', 's', '-', '<C-w>+')
