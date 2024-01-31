return {
  {
    "00sapo/visual.nvim",
    enabled = false,
    opts = {
      commands = {
        move_up_then_normal = { amend = true },
        move_down_then_normal = { amend = true },
        move_right_then_normal = { amend = true },
        move_left_then_normal = { amend = true },
      },
    },
    dependencies = { "nvim-treesitter", "nvim-treesitter-textobjects" },
    event = "VeryLazy",
  },
}
