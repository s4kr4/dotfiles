local config_dir = "00_plugins/config/"

return {
  {
    "jacoborus/tender",
    config = function()
      require(config_dir.."tender")
    end
  },
}

