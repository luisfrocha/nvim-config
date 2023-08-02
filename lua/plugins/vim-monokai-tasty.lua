return {
  {
    "patstockwell/vim-monokai-tasty",
    dependencies = {
      "HerringtonDarkholme/yats.vim",
      "pangloss/vim-javascript",
      "MaxMEllon/vim-jsx-pretty",
      "styled-components/vim-styled-components",
      "elzr/vim-json",
      "jparise/vim-graphql",
    },
    init = function()
      vim.g.vim_monokai_tasty_italic = 1
      vim.g.vim_monokai_tasty_machine_tint = 1
      vim.g.vim_monokai_tasty_highlight_active_window = 1
      -- vim.g.lightline.colorscheme = "monokai_tasty"
      -- vim.g.airline_theme = "monokai_tasty"
    end,
  },
}
