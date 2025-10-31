return {
  "mason-org/mason.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    -- Hook into Mason's install process for vue-language-server
    vim.defer_fn(function()
      local mason_registry = require("mason-registry")
      if mason_registry.has_package("vue-language-server") then
        local vue_ls_pkg = mason_registry.get_package("vue-language-server")
        local original_install = vue_ls_pkg.install

        vue_ls_pkg.install = function(self, ...)
          -- Store original registry
          local original_registry = vim.env.npm_config_registry

          -- Temporarily set npm registry to official npm for vue-language-server
          vim.env.npm_config_registry = "https://registry.npmjs.org"

          local result = original_install(self, ...)

          -- Restore original registry
          vim.env.npm_config_registry = original_registry

          return result
        end
      end
    end, 100)

    local mason_tool_installer = require("mason-tool-installer")
    mason_tool_installer.setup({
      ensure_installed = {
        "css-lsp",
        "cssmodules-language-server",
        "elixir-ls",
        "emmet-ls",
        "eslint-lsp",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "tailwindcss-language-server",
        "htmlbeautifier",
        "vue-language-server",
        "rustywind",
        "yaml-language-server",
      },
    })
  end,
}
