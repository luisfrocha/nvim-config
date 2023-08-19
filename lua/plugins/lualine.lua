return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", { "fabius/molokai.nvim", lazy = false } },
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        theme = "molokai",
      },
      sections = {
        lualine_x = {
          function()
            return require("package-info").get_status()
          end,
          "encoding",
          "fileformat",
          "filetype",
        },
      },
    },
  },
}
