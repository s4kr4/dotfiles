require("barbar").setup({
  animation = true,
  auto_hide = false,
  tabpages = true,
  clickable = true,
})

vim.keymap.set("", "<C-h>", "<Cmd>BufferPrevious<CR>", { noremap = true, silent = true })
vim.keymap.set("", "<C-l>", "<Cmd>BufferNext<CR>", { noremap = true, silent = true })

