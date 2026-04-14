-- Performance and startup optimizations for LazyVim
return {
  -- Better startup performance
  {
    "lewis6991/impatient.nvim",
    event = "VimEnter",
    config = function()
      require("impatient").enable_profile()
    end,
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },

  -- Better yanking/clipboard
  {
    "gbprod/yanky.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    opts = {
      ring = { storage = "sqlite" },
    },
    keys = {
      {
        "<leader>p",
        function()
          require("yanky.telescope").yank_history()
        end,
        desc = "Open Yank History",
      },
      {
        "y",
        "<Plug>(YankyYank)",
        mode = { "n", "x" },
        desc = "Yank text",
      },
      {
        "p",
        "<Plug>(YankyPutAfter)",
        mode = { "n", "x" },
        desc = "Put yanked text after cursor",
      },
      {
        "P",
        "<Plug>(YankyPutBefore)",
        mode = { "n", "x" },
        desc = "Put yanked text before cursor",
      },
      {
        "gp",
        "<Plug>(YankyGPutAfter)",
        mode = { "n", "x" },
        desc = "Put yanked text after selection",
      },
      {
        "gP",
        "<Plug>(YankyGPutBefore)",
        mode = { "n", "x" },
        desc = "Put yanked text before selection",
      },
      {
        "[y",
        "<Plug>(YankyCycleForward)",
        desc = "Cycle forward through yank history",
      },
      {
        "]y",
        "<Plug>(YankyCycleBackward)",
        desc = "Cycle backward through yank history",
      },
    },
  },

  -- Smart splits
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    keys = {
      {
        "<C-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "Move to left split",
      },
      {
        "<C-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "Move to below split",
      },
      {
        "<C-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "Move to above split",
      },
      {
        "<C-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "Move to right split",
      },
      {
        "<C-Up>",
        function()
          require("smart-splits").resize_up()
        end,
        desc = "Resize split up",
      },
      {
        "<C-Down>",
        function()
          require("smart-splits").resize_down()
        end,
        desc = "Resize split down",
      },
      {
        "<C-Left>",
        function()
          require("smart-splits").resize_left()
        end,
        desc = "Resize split left",
      },
      {
        "<C-Right>",
        function()
          require("smart-splits").resize_right()
        end,
        desc = "Resize split right",
      },
    },
  },

  -- Multi-cursor support
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    keys = {
      { "<C-n>", desc = "Select word under cursor" },
      { "<C-Down>", desc = "Create cursor below" },
      { "<C-Up>", desc = "Create cursor above" },
    },
  },
}
