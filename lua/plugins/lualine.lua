return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { { "fabius/molokai.nvim", lazy = false }, "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        theme = "onedark",
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
