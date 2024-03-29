local icon
if vim.fn.has("macunix") then
  icon = ""
else
  icon = ""
end
return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
          { "fileformat", symbols = { unix = icon } },
          "filetype",
        },
      },
    },
  },
}
