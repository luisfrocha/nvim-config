return {
  {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = false },
    "patstockwell/vim-monokai-tasty",
    "oxfist/night-owl.nvim",
    "hachy/eva01.vim",
    "ChristianChiarulli/onedark.nvim",
    "MannyFay/mannydark.nvim",
    { "antonyz89/electron-vue.nvim", dependencies = { "rktjmp/lush.nvim" } },
    "cosmicthemethhead/ultradark.nvim",
    "rebelot/kanagawa.nvim",
    "rafamadriz/themes.nvim",
    { "tersetears/maani.nvim", dependencies = { "rktjmp/lush.nvim" } },
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
    },
    {
      "fabius/molokai.nvim",
      name = "molokai",
      dependencies = { "rktjmp/lush.nvim" },
      lazy = false,
      priority = 1000,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "molokai",
    },
  },
}
