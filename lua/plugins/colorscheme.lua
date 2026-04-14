return {
  -- 🎨 RECOMMENDED COLORSCHEMES (uncomment others below if needed)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      dimInactive = true,
      theme = "wave",
      background = {
        dark = "wave",
        light = "lotus",
      },
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
      },
    },
  },

  -- 💤 ADDITIONAL COLORSCHEMES (commented for performance)
  -- Uncomment any you want to try:

  -- {
  --   "sainnhe/sonokai",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.g.sonokai_enable_italic = 1
  --     vim.g.sonokai_cursor = "yellow"
  --     vim.g.sonokai_transparent_background = 2
  --     vim.g.sonokai_dim_inactive_windows = 1
  --     vim.g.sonokai_style = "shusia"
  --     vim.g.sonokai_better_performance = 1
  --   end,
  -- },

  -- { "patstockwell/vim-monokai-tasty", lazy = false },
  -- { "oxfist/night-owl.nvim", lazy = false },
  -- { "hachy/eva01.vim", lazy = false },
  -- { "ChristianChiarulli/onedark.nvim", lazy = false },
  -- { "MannyFay/mannydark.nvim", lazy = false },
  -- { "antonyz89/electron-vue.nvim", lazy = false, dependencies = { "rktjmp/lush.nvim" } },
  -- { "tersetears/maani.nvim", lazy = false, dependencies = { "rktjmp/lush.nvim" } },
  -- { "UtkarshVerma/molokai.nvim", lazy = false, priority = 1000 },
  -- {
  --   "neanias/everforest-nvim",
  --   version = false,
  --   lazy = false,
  --   priority = 1000,
  -- },
  -- { "lunarvim/Onedarker.nvim" },
  -- { "fnune/standard", lazy = false, priority = 1000 },
  -- {
  --   "patstockwell/vim-monokai-tasty",
  --   dependencies = {
  --     "HerringtonDarkholme/yats.vim",
  --     "pangloss/vim-javascript",
  --     "MaxMEllon/vim-jsx-pretty",
  --     "elzr/vim-json",
  --     "styled-components/vim-styled-components",
  --     "itchyny/lightline.vim",
  --     "vim-airline/vim-airline",
  --   },
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.g.vim_monokai_tasty_italic = 1
  --     vim.g.vim_monokai_tasty_machine_tint = 1
  --     vim.g.vim_monokai_tasty_highlight_active_window = 1
  --   end,
  -- },
  -- { "cpea2506/one_monokai.nvim", lazy = false, priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
