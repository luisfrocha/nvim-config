return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "stephpy/vim-php-cs-fixer" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "vue-language-server",
          "prettierd",
          -- "prettier",
          "lua-language-server",
          "eslint-lsp",
          "js-debug-adapter",
          "json-lsp",
          "shfmt",
          "stylua",
          "tailwindcss-language-server",
          "typescript-language-server",
          "intelephense",
          "php-cs-fixer",
          "stylelint",
        },
        auto_update = true,
      })
    end,
  },
}
