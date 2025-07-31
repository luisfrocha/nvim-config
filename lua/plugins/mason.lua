return {
  "williamboman/mason.nvim",
  url = "https://github.com/iguanacucumber/mason.nvim",
  branch = "next",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
    local mason_tool_installer = require("mason-tool-installer")
    mason_tool_installer.setup({
      ensure_installed = {
        "cssls",
        "cssmodules_ls",
        "diagnosticls",
        "elixir-ls",
        "emmet_ls",
        "eslint",
        "eslint-lsp", -- js linter
        "html",
        "htmlbeautifier",
        "intelephense", -- PHP formatter
        "jsonls",
        "lexical",
        "lua_ls",
        "lua-language-server",
        "marksman",
        "prettier",
        "prettierd", -- prettier formatter
        "stylelint",
        "stylua", -- lua formatter
        "tailwindcss",
        "volar",
        "vue-language-server",
        "yaml-language-server", -- handle yaml files
        "yamlls",
      },
      auto_update = true,
      run_on_start = true,
    })
  end,
}
