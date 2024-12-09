return {
    "folke/persistence.nvim",
    dependencies = { "lukas-reineke/indent-blankline.nvim" },
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {},
  }
