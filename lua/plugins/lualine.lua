local icon
if vim.fn.has("macunix") then
  icon = ""
else
  icon = ""
end
return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "meuter/lualine-so-fancy.nvim",
  },
  lazy = false,
  event = { "BufReadPost", "BufNewFile", "VeryLazy" },
  config = function()
    -- local icons = require("config.icons")
    require("lualine").setup({
      options = {
        theme = "auto",
        -- theme = "catppuccin",
        globalstatus = true,
        icons_enabled = true,
        -- component_separators = { left = "│", right = "│" },
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {
            "alfa-nvim",
            "help",
            "neo-tree",
            "Trouble",
            "spectre_panel",
            "toggleterm",
          },
          winbar = {},
        },
      },
      sections = {
        lualine_a = {},
        lualine_b = {
          "fancy_branch",
        },
        lualine_c = {
          {
            "filename",
            path = 1, -- 2 for full path
            symbols = {
              modified = "  ",
              -- readonly = "  ",
              unnamed = "  ",
            },
          },
          { "fancy_diagnostics", sources = { "nvim_lsp" }, symbols = { error = " ", warn = " ", info = " " } },
          { "fancy_searchcount" },
          { require("auto-session.lib").current_session_name },
        },
        lualine_x = {
          function()
            return require("package-info").get_status()
          end,
          "encoding",
          { "fileformat", symbols = { unix = icon } },
          "filetype",
          -- "fancy_lsp_servers",
          "fancy_diff",
          "progress",
        },
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        -- lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { "neo-tree", "lazy" },
    })
  end,
}
