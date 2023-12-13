return {
  "VonHeikemen/searchbox.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  keys = {
    {
      "<C-f>",
      ":SearchBoxMatchAll show_matches=true<cr>",
      desc = "Search in Buffer",
    },
    {
      "<C-r>",
      ":SearchBoxReplace show_matches=true confirm=menu<cr>",
      desc = "Search & Replace in Buffer",
    },
  },
}
