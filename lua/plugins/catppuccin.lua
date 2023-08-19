return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      transparent_background = true,
      integrations = {
        telescope = true,
        harpoon = true,
        mason = true,
        neotest = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
    end,
  },
}
