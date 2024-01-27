return {
  {
    "anuvyklack/windows.nvim",
    event = "VeryLazy",
    enabled = false,
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    init = function()
      require("windows").setup({
        autowidth = {
          winminwidth = 0.25,
          winwidth = 100,
          equalalways = false,
        },
      })
    end,
    keys = {
      { "<c-w>z", "<cmd>WindowsMaximize<cr>", mode = "n", desc = "Maximize window" },
      { "<c-w>_", "<cmd>WindowsMaximizeVertically<cr>", mode = "n", desc = "Maximize window vertically" },
      { "<c-w>|", "<cmd>WindowsMaximizeHorizontally<cr>", mode = "n", desc = "Maximize window horizontally" },
      { "<c-w>=", "<cmd>WindowsEqualize<cr>", mode = "n", desc = "Equalize window" },
    },
  },
}
