--------------------------------------------------------------------
-- Keymap Settings
--------------------------------------------------------------------

local keymap = vim.api.nvim_set_keymap
local options = {
  noremap = true,
  silent = true,
}

keymap("", "<Space>", "<Nop>", options)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- normal mode
keymap("n", "j", "gj", options)
keymap("n", "k", "gk", options)
keymap("n", "<C-j>", "<C-e>", options)
keymap("n", "<C-k>", "<C-y>", options)
keymap("n", "<C-a>", "^", options)
keymap("n", "<C-e>", "$", options)
keymap("n", "<TAB>", "<C-w>w", options)
keymap("n", "<S-TAB>", "<C-w>W", options)
keymap("n", "<C-q>", ":q<CR>", options)

keymap("n", "day", '<ESC>a<C-r>=strftime("%Y-%m-%d ")<CR><ESC>', options)
keymap("n", "time", '<ESC>a<C-r>=strftime("%H:%M:%S ")<CR><ESC>', options)

-- if vim.fn.has("mac") then
--   keymap("n", ";", ":", options)
--   keymap("n", ":", ";", options)
-- end

-- insert mode
keymap("i", "<C-j>", "<ESC>", options)

keymap("i", "<C-f>", "<Right>", options)
keymap("i", "<C-b>", "<Left>", options)
keymap("i", "<C-p>", "<Up>", options)
keymap("i", "<C-n>", "<Down>", options)

keymap("i", "{<Enter>", "{}<Left><CR><ESC><S-o>", options)
keymap("i", "(<Enter>", "()<Left><CR><ESC><S-o>", options)
keymap("i", "[<Enter>", "[]<Left><CR><ESC><S-o>", options)
keymap("i", '""', '""<Left>', options)
keymap("i", "''", "''<Left>", options)
keymap("i", "``", "``<Left>", options)

-- visual mode
keymap("v", "G", "G$", options)


-- if !has('nvim') && executable('fzy')
--   nnoremap <leader>e :call FzyCommand("find . -type f", ":e")<CR>
--   nnoremap <leader>v :call FzyCommand("find . -type f", ":vs")<CR>
--   nnoremap <leader>s :call FzyCommand("find . -type f", ":sp")<CR>
-- endif

