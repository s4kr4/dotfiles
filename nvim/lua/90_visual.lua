--------------------------------------------------------------------
-- Visual Settings
--------------------------------------------------------------------

local options = {
  -- display row number
  number = true,

  -- display cursor line
  cursorline = true,

  -- visible whitespace
  list = true,
  listchars = {
    tab="»-",
    trail="-",
    extends="»",
    precedes="«",
    nbsp="%",
    eol="↲",
  },

  -- display statusline
  laststatus = 2,

  -- Enable syntax highlight
  syntax = "enable",

  -- Highlight search words
  hlsearch = true,

  -- Scroll offset
  scrolloff = 3,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd([[
" highlight ideographic spaces
augroup highlightSpace
  autocmd!
  autocmd Colorscheme * hi IdeographicSpace term=underline ctermbg=DarkRed guibg=DarkRed
  autocmd VimEnter,WinEnter * match IdeographicSpace /　\|\s\+$/
augroup END

" Display cursorline
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

" Transparent
highlight Normal ctermbg=NONE
highlight NonText ctermbg=NONE
highlight SpecialKey ctermbg=NONE
highlight EndOfBuffer ctermbg=NONE
highlight LineNr ctermbg=NONE ctermfg=008

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
