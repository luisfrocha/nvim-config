return {
  "saecki/live-rename.nvim",
  keys = {

    {
      "<leader>lr",
      function()
        require("live-rename").rename({})
      end,
      desc = "Rename current variable",
    },
  },
}
