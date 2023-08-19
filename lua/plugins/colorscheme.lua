return {
  {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = false },
    { "patstockwell/vim-monokai-tasty", lazy = false },
    { "oxfist/night-owl.nvim", lazy = false },
    { "hachy/eva01.vim", lazy = false },
    { "ChristianChiarulli/onedark.nvim", lazy = false },
    { "MannyFay/mannydark.nvim", lazy = false },
    { "antonyz89/electron-vue.nvim", lazy = false, dependencies = { "rktjmp/lush.nvim" } },
    { "cosmicthemethhead/ultradark.nvim", lazy = false },
    { "rebelot/kanagawa.nvim", lazy = false },
    { "rafamadriz/themes.nvim", lazy = false },
    { "tersetears/maani.nvim", lazy = false, dependencies = { "rktjmp/lush.nvim" } },
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
    },
    { "UtkarshVerma/molokai.nvim", lazy = false, priority = 1000 },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "molokai",
    },
  },
}
