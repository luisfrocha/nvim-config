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
        -- 🗂️ LANGUAGE SERVERS
        "json-lsp",                    -- JSON support
        "sqls",                        -- SQL language server
        "vue-language-server",         -- Vue/Nuxt support (Volar)
        "vtsls",                       -- TypeScript/React support
        "tailwindcss-language-server", -- Tailwind CSS
        "css-lsp",                     -- CSS/SCSS support
        "html-lsp",                    -- HTML support
        "emmet-ls",                    -- HTML/CSS expansions
        -- NOTE: oxc-language-server is not in Mason's registry yet — skip for now
        "lua-language-server",         -- Lua (essential for Neovim config!)

        -- ⚡ FORMATTERS & LINTERS
        "oxlint",  -- Fast JS/TS linter (replaces eslint_d)
        "oxfmt",   -- Fast formatter, reads .prettierrc (replaces prettierd)
        "stylua",  -- Lua formatter (for Neovim config)

        -- 📝 NOTES:
        -- • Elixir uses elixir-tools (NextLS), not Mason
        -- • Removed unnecessary tools: cssmodules, htmlbeautifier, rustywind, yaml
        -- • Kept lua-language-server for Neovim config development
      },
    })
  end,
}
