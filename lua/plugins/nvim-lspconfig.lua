return {
  "neovim/nvim-lspconfig",
  dependencies = { "bmatcuk/stylelint-lsp" },
  config = function()
    local nvim_lsp = require("lspconfig")

    nvim_lsp.stylelint_lsp.setup({
      settings = {
        stylelintplus = {
          autoFixOnSave = true,
          autoFixOnFormat = true,
        },
      },
    })
  end,
}
