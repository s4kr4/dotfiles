require("telescope").setup {
  defaults = {
    layout_config = {
      width = 0.75,
    },
    file_ignore_patterns = {
      "%.git/",
      "%vendor",
    },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
  },
}

vim.api.nvim_set_keymap("n", "<Leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>fg", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>fb", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>fh", "<cmd>Telescope help_tags<CR>", { noremap = true, silent = true })

