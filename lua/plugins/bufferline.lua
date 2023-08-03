return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
  },
  opts = {
    options = {
      diagnostics = false,
      separator_style = "thin", -- slant, padded_slant, slope, padded_slope, thick, thin, or custom list
      indicator = {
        style = "underline",
      },
      hover = {
        enabled = true,
        delay = 50,
        reveal = { "close" },
      },
      always_show_bufferline = true,
      highlights = {
        tab_separator = { fg = "#000000" },
      },
    },
  },
}
