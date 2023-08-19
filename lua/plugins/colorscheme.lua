return {
  {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = true },
    { "patstockwell/vim-monokai-tasty", lazy = true },
    { "oxfist/night-owl.nvim", lazy = true },
    { "hachy/eva01.vim", lazy = true },
    { "ChristianChiarulli/onedark.nvim", lazy = true },
    { "MannyFay/mannydark.nvim", lazy = true },
    { "antonyz89/electron-vue.nvim", lazy = true, dependencies = { "rktjmp/lush.nvim" } },
    { "cosmicthemethhead/ultradark.nvim", lazy = true },
    { "rebelot/kanagawa.nvim", lazy = true },
    { "rafamadriz/themes.nvim", lazy = true },
    { "tersetears/maani.nvim", lazy = true, dependencies = { "rktjmp/lush.nvim" } },
    {
      "folke/tokyonight.nvim",
      lazy = true,
      priority = 1000,
    },
    {
      "fabius/molokai.nvim",
      dependencies = { "RRethy/nvim-base16", "rktjmp/lush.nvim" },
      lazy = true,
      priority = 1000,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "molokai",
      init = function()
        print("Loaded")
      end,
    },
  },
}
