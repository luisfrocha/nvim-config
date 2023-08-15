return {
  "windwp/nvim-ts-autotag",
  event = "VeryLazy",
  init = function()
    require("nvim-ts-autotag").setup()
  end,
}
