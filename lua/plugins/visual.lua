return {
  {
    "00sapo/visual.nvim",
    config = function()
      require("visual").setup({
        commands = {
          move_up_then_normal = { amend = true },
          move_down_then_normal = { amend = true },
          move_right_then_normal = { amend = true },
          move_left_then_normal = { amend = true },
        },
      })
    end,
    event = "VeryLazy",
  },
}
