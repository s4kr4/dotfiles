--------------------------------------------------------------------
-- Edit Settings
--------------------------------------------------------------------

local options = {
  backspace = "start,eol,indent",
  wildmode = "list:full",
  wildignorecase = true,
  expandtab = true,
  tabstop = 4,
  softtabstop = 4,
  shiftwidth = 4,
  shiftround = true,
  autoindent = true,
  hidden = true,
  switchbuf = "useopen",

  -- highlight corresponding brakets
  showmatch = true,

  -- wrap line
  wrap = true,

  -- no break in the middle of words
  linebreak = true,

  fixeol = false,

  conceallevel = 0,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

