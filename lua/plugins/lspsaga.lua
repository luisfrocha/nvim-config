return {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("lspsaga").setup({})
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = { { "<C-.>", ":Lspsaga code_action<cr>", mode = { "n" }, desc = "Show code actions menu" } },
  },
}
