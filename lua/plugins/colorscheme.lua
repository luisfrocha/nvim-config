return {
  {
    -- { "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = false },
    -- { "patstockwell/vim-monokai-tasty", lazy = false },
    -- { "oxfist/night-owl.nvim", lazy = false },
    -- { "hachy/eva01.vim", lazy = false },
    -- { "ChristianChiarulli/onedark.nvim", lazy = false },
    -- { "MannyFay/mannydark.nvim", lazy = false },
    -- { "antonyz89/electron-vue.nvim", lazy = false, dependencies = { "rktjmp/lush.nvim" } },
    -- { "cosmicthemethhead/ultradark.nvim", lazy = false },
    { "rebelot/kanagawa.nvim", lazy = false },
    -- { "rafamadriz/themes.nvim", lazy = false },
    -- { "tersetears/maani.nvim", lazy = false, dependencies = { "rktjmp/lush.nvim" } },
    -- {
    --   "folke/tokyonight.nvim",
    --   lazy = false,
    --   priority = 1000,
    -- },
    -- { "UtkarshVerma/molokai.nvim", lazy = false, priority = 1000 },
    -- {
    --   "neanias/everforest-nvim",
    --   version = false,
    --   lazy = false,
    --   priority = 1000, -- make sure to load this before all the other start plugins
    --   -- Optional; default configuration will be used if setup isn't called.
    --   config = function()
    --     require("everforest").setup({
    --       -- Your config here
    --     })
    --   end,
    -- },
    -- { "lunarvim/Onedarker.nvim" },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
