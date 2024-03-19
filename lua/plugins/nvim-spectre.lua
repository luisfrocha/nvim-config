return {
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<C-S-F>",
        '<cmd>lua require("spectre").open_visual({select_word=true,is_insert_mode=true,live_update=true})<CR>',
        desc = "Global Search",
      },
    },
    opts = {
      is_insert_mode = true,
      select_word = true,
      live_update = true,
      lnum_for_results = true,
      color_devicons = true,
      default = { find = { options = {} } },
    },
  },
}
