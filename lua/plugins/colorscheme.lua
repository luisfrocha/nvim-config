return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        transparent = true,
        dimInactive = true,
        terminalColors = true,
        overrides = function(colors)
          return {
            IlluminatedWordText = { bg = colors.palette.fujiGray },
            IlluminatedWordRead = { bg = colors.palette.fujiGray },
            IlluminatedWordWrite = { bg = colors.palette.fujiGray },
          }
        end,
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },
}
