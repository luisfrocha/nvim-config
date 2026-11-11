return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    "mason.nvim",
  },
  opts = {
    ensure_installed = {
      "cssls",
      "cssmodules_ls",
      "elixirls", -- Used by LazyVim's Elixir extra
      "emmet_ls",
      "eslint",
      "html",
      "jsonls",
      "lua_ls",
      "tailwindcss",
      "yamlls",
    },
  },
}
