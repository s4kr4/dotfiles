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
  }
}

