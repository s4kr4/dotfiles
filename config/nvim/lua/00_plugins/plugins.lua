local config_dir = "00_plugins/config/"

return {
  {
    "jacoborus/tender",
    config = function()
      require(config_dir.."tender")
    end
  },
  {
    "tyru/caw.vim",
    config = function()
      require(config_dir.."caw")
    end
  },
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
    },
    config = function()
      require(config_dir.."git-blame")
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require(config_dir.."hlchunk")
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.1",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require(config_dir.."telescope")
    end
  },
  {
    "romgrk/barbar.nvim",
    version = "^1.0.0",
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    config = function()
      require(config_dir.."barbar")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP補完ソース
      "hrsh7th/cmp-buffer", -- バッファ補完ソース
      "hrsh7th/cmp-path", -- パス補完ソース
      "hrsh7th/cmp-cmdline", -- コマンドライン補完ソース
      "hrsh7th/cmp-vsnip", -- スニペット
      "hrsh7th/vim-vsnip", -- スニペット
    },
    lazy = true,
    config = function()
      require(config_dir.."nvim-cmp")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require(config_dir.."nvim-lspconfig")
    end,
  },
}

