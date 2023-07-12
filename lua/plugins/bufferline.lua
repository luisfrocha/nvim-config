return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
  },
  opts = {
    options = {
      separator_style = "slant",
      indicator = {
        style = "underline",
      },
      hover = {
        enabled = true,
        delay = 200,
        reveal = { "close" },
      },
      always_show_bufferline = true,
      -- highlights = {
      --   tab_separator = {
      --     bg = "none",
      --     fg = "none",
      --   },
      -- },
    },
  },
}
