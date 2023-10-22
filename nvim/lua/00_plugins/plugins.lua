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
  }
}

