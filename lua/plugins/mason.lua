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
        "prettierd", -- prettier formatter
        "stylua", -- lua formatter
        "eslint-lsp", -- js linter
        "intelephense", -- PHP formatter
        "pretty-php", --- PHP
        "yaml-language-server", -- handle yaml files
        "stylelint",
        "lua-language-server",
        "rustywind",
        "hadolint",
        "shfmt",
        "vue-language-server",
      },
    })
  end,
}
