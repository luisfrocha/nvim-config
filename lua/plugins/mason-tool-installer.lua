return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "vue-language-server",
          "prettierd",
          "prettier",
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
        },
        auto_update = true,
      })
    end,
  },
}
