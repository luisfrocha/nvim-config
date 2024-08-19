return {
  "folke/which-key.nvim",
  dependencies = { { "echasnovski/mini.icons", version = false } },
  event = "VeryLazy",
  lazy = true,
  opts = {
    plugins = {
      marks = false, -- shows a list of your marks on ' and `
      registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      presets = {
        operators = false, -- adds help for operators like d, y, ...
        motions = false, -- adds help for motions
        text_objects = false, -- help for text objects triggered after entering an operator
        windows = false, -- default bindings on <c-w>
        nav = false, -- misc bindings to work with windows
        z = false, -- bindings for folds, spelling and others prefixed with z
        g = false, -- bindings for prefixed with g
      },
    },
    defer = { gc = "Comments" }, -- show the currently pressed key and its label as a message in the command line
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = require("config.icons").ui.BoldArrowRight, -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },
    keys = {
      scroll_down = "<c-d>", -- binding to scroll down inside the popup
      scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    win = {
      border = "single", -- none, single, double, shadow
      no_overlap = false,
      padding = { 1, 0 }, -- extra window padding [top, right, bottom, left]
      wo = { winblend = 10 },
    },
    layout = {
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 3, -- spacing between columns
    },
    -- -- Disabled by default for Telescope
    disable = {
      bt = {},
      ft = { "TelescopePrompt" },
    },
  },
  config = function(_, opts)
    local which_key = require("which-key")
    which_key.setup(opts)
    which_key.add(require("config.which-key.defaults"), {
      mode = "n",
      prefix = "<leader>",
    })

    which_key.add(require("config.which-key.non_leader"))
  end,
}
