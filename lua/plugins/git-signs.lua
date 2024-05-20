return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    enabled = false,
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { delay = 400 },
      numhl = true,
      -- linehl = true,
      signcolumn = false,
      word_diff = true,
      watch_gitdir = { follow_files = true },
    },
  },
}
