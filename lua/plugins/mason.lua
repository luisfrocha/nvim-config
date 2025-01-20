return {
  "williamboman/mason.nvim",
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
        "bashls",
        "black",
        "cssls",
        "cssmodules_ls",
        "curlylint",
        "diagnosticls",
        "docker_compose_language_service",
        "dockerls",
        "elixir-ls",
        "emmet_ls",
        "eslint",
        "eslint-lsp", -- js linter
        "html",
        "htmlbeautifier",
        "intelephense", -- PHP formatter
        "isort",
        "jsonls",
        "lexical",
        "lua_ls",
        "lua-language-server",
        "marksman",
        "nextls",
        "prettier",
        "prettierd", -- prettier formatter
        "pretty-php", --- PHP
        "ruff",
        "shfmt",
        "sqlls",
        "stylelint",
        "stylua", -- lua formatter
        "tailwindcss",
        "trivy",
        -- "tsserver",
        "volar",
        "vue-language-server",
        "yaml-language-server", -- handle yaml files
        "yamlls",
      },
      automatic_installation = true,
    })
  end,
}
