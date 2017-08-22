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

call submode#enter_with('winmove', 'n', 's', '<Space>h', '<C-w>h')
call submode#enter_with('winmove', 'n', 's', '<Space>j', '<C-w>j')
call submode#enter_with('winmove', 'n', 's', '<Space>k', '<C-w>k')
call submode#enter_with('winmove', 'n', 's', '<Space>l', '<C-w>l')

call submode#map('winmove', 'n', 's', 'h', '<C-w>h')
call submode#map('winmove', 'n', 's', 'j', '<C-w>j')
call submode#map('winmove', 'n', 's', 'k', '<C-w>k')
call submode#map('winmove', 'n', 's', 'l', '<C-w>l')

