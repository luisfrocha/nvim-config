return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      numhl = true,
      linehl = true,
      word_diff = true,
    },
  },
}
