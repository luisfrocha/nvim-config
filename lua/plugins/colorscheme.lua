return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { transparent = true, styles = { sidebars = "transparent", floats = "transparent" } },
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = { transparent = true, dimInactive = true, theme = "wave", background = { dark = "wave", light = "lotus" } },
    -- config = function()
    --   vim.cmd.colorscheme = "kanagawa"
    -- end,
  },
  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_cursor = "yellow"
      vim.g.sonokai_transparent_background = 2
      vim.g.sonokai_dim_inactive_windows = 1
      vim.g.sonokai_style = "shusia"
      vim.g.sonokai_better_performance = 1
      -- vim.cmd.colorscheme("sonokai")
    end,
  },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = false },
  { "patstockwell/vim-monokai-tasty", lazy = false },
  { "oxfist/night-owl.nvim", lazy = false },
  { "hachy/eva01.vim", lazy = false },
  { "ChristianChiarulli/onedark.nvim", lazy = false },
  { "MannyFay/mannydark.nvim", lazy = false },
  { "antonyz89/electron-vue.nvim", lazy = false, dependencies = { "rktjmp/lush.nvim" } },
  -- { "rafamadriz/themes.nvim", lazy = false },
  { "tersetears/maani.nvim", lazy = false, dependencies = { "rktjmp/lush.nvim" } },
  { "UtkarshVerma/molokai.nvim", lazy = false, priority = 1000 },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    -- config = function()
    --   require("everforest").setup({
    --     -- Your config here
    --   })
    -- end,
  },
  { "lunarvim/Onedarker.nvim" },
  {
    "fnune/standard",
    lazy = false,
    priority = 1000,
  },
  {
    "patstockwell/vim-monokai-tasty",
    dependencies = {
      "HerringtonDarkholme/yats.vim",
      "pangloss/vim-javascript",
      "MaxMEllon/vim-jsx-pretty",
      "elzr/vim-json",
      "styled-components/vim-styled-components",
      "itchyny/lightline.vim",
      "vim-airline/vim-airline",
    },
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.vim_monokai_tasty_italic = 1
      vim.g.vim_monokai_tasty_machine_tint = 1
      vim.g.vim_monokai_tasty_highlight_active_window = 1
    end,
  },
  { "cpea2506/one_monokai.nvim", lazy = false, priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
