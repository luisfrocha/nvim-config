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
      -- vim.cmd.colorscheme("kanagawa")
    end,
  },
  {
    "oxfist/night-owl.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      require("night-owl").setup()
      -- vim.cmd.colorscheme("night-owl")
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup()
      -- vim.cmd.colorscheme('cyberdream')
    end,
  },
  {
    "dasupradyumna/midnight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("midnight").setup({ HighlightGroup = { clear = true } })
      -- vim.cmd.colorscheme('midnight')
    end,
  },
  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("modus-themes").setup({ style = "modus_vivendi", variant = "tritanopia", transparent = true })
      -- vim.cmd.colorscheme('modus')
    end,
  },
  {
    "JoosepAlviste/palenightfall.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("palenightfall").setup({ transparent = true })
      -- vim.cmd.colorscheme('palenightfall')
    end,
  },
  {
    "zootedb0t/citruszest.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("citruszest").setup({
        option = { transparent = true, bold = true, italic = true },
      })
      -- vim.cmd.colorscheme('citruszest')
    end,
  },
  {
    "hachy/eva01.vim",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme "eva01"
      -- or
      -- vim.cmd.colorscheme "eva01-LCL"
    end,
  },
  {
    "polirritmico/monokai-nightasty.nvim",
    lazy = false,
    priority = 1000,
    keys = {
      { "<leader>tt", "<Cmd>MonokaiToggleLight<CR>", desc = "Monokai-Nightasty: Toggle dark/light theme." },
    },
    ---@type monokai.UserConfig
    opts = {
      dark_style_background = "transparent",
      light_style_background = "transparent",
      hl_styles = { floats = "transparent", sidebars = "transparent" },
      markdown_header_marks = true,
      -- hl_styles = { comments = { italic = false } },
      terminal_colors = function(colors)
        return { fg = colors.fg_dark }
      end,
    },
    config = function(_, opts)
      vim.opt.cursorline = true -- Highlight line at the cursor position
      vim.o.background = "dark" -- Default to dark theme

      require("monokai-nightasty").load(opts)
      -- vim.cmd.colorscheme 'monokai-nightasty'
    end,
  },
  {
    "yorumicolors/yorumi.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'yorumi'
    end,
  },
  {
    "AstroNvim/astrotheme",
    lazy = false,
    priority = 1000,
    config = function()
      require("astrotheme").setup({
        palette = "astrodark",
        style = { transparent = true },
      })
      -- vim.cmd.colorscheme 'astrotheme'
    end,
  },
  {
    "lunarvim/Onedarker.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedarker").setup()
      -- vim.cmd.colorscheme 'onedarker'
    end,
  },
  {
    "fynnfluegge/monet.nvim",
    name = "monet",
    lazy = false,
    priority = 1000,
    config = function()
      require("monet").setup({ transparent_background = true })
      -- vim.cmd.colorscheme 'monet'
    end,
  },
  {
    "yorik1984/newpaper.nvim",
    priority = 1000,
    config = function()
      require("newpaper").setup({
        style = "dark",
        terminal = "inverse_transparent",
        regex = "bold,italic",
        disable_background = true,
      })
      -- vim.cmd.colorscheme 'newpaper'
    end,
  },
  {
    "Alexis12119/nightly.nvim",
    lazy = false,
    priority = 1000,
    -- config = function()
    --   vim.cmd.colorscheme "nightly"
    -- end,
  },
  {
    "lewpoly/sherbet.nvim",
    lazy = false,
    priority = 1000,
    -- config = function()
    --   vim.cmd.colorscheme 'sherbet'
    -- end
  },
  {
    "killitar/obscure.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    -- config = function()
    -- vim.cmd.colorscheme 'obscure'
    -- end
  },
  {
    "tanvirtin/monokai.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("monokai").setup()
      -- vim.cmd.colorscheme "monokai"
    end,
  },
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("monokai-pro").setup({
        transparent_background = true,
        filter = "pro",
      })
      -- vim.cmd.colorscheme "monokai-pro"
    end,
  },
  {
    "cpea2506/one_monokai.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("one_monokai").setup({ transparent = true })
      -- vim.cmd.colorscheme("one_monokai")
    end,
  },
  {
    "sainnhe/sonokai",
    priority = 1000,
    lazy = false,
    config = function()
      require("sonokai").setup()
      vim.cmd.colorscheme("sonokai")
    end,
  },
}
