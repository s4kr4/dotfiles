--------------------------------------------------------------------
--  General Settings
--------------------------------------------------------------------

vim.cmd("autocmd!")

-- Enable settings depends on filetype
vim.cmd("filetype plugin indent on")

vim.scriptencoding = "utf-8"

vim.ttymouse = "xterm2"

local options = {
  encoding = "utf-8",
  fileencoding = "utf-8",

  -- Enable using mouse
  mouse = "a",

  -- Enable incremental search
  incsearch = true,
  ignorecase = true,
  smartcase = true,

  -- Don't make backup files and swapfile
  writebackup = false,
  backup = false,
  swapfile = false,
  undofile = false,

  -- Disable ring beep
  -- set vb t_vb=

  whichwrap = "b,s,h,l,<,>,[,]",

  completeopt = "menuone",

  -- Open new panes in the below or right
  splitbelow = true,
  splitright = true,

  -- Share clipboard with other editor
  clipboard = "unnamedplus",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
        name = "win32yank-wsl",
  copy = {
    ["+"] = "win32yank.exe -i --crlf",
    ["*"] = "win32yank.exe -i --crlf"
    },
  paste = {
    ["+"] = "win32yank.exe -o --crlf",
    ["*"] = "win32yank.exe -o --crlf"
  },
  cache_enable = 0,
  }
end

