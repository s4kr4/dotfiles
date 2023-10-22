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
]])
