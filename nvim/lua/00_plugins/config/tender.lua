--------------------------------------------------------------------
-- jacoborus/tender.vim
--------------------------------------------------------------------

vim.cmd "colorscheme tender"
vim.cmd([[
" Transparent
highlight Normal ctermbg=NONE
highlight NonText ctermbg=NONE
highlight SpecialKey ctermbg=NONE
highlight EndOfBuffer ctermbg=NONE
highlight LineNr ctermbg=NONE ctermfg=008

" Display cursorline
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

" Comment
highlight Comment ctermfg=79

" Selection
highlight Visual ctermbg=26

" vimdiff
highlight DiffAdd ctermfg=15 ctermbg=22
highlight DiffDelete ctermfg=52 ctermbg=52
highlight DiffChange ctermfg=15 ctermbg=17
highlight DiffText ctermfg=15 ctermbg=27

" StatusLine
highlight StatusLine ctermfg=15
]])

