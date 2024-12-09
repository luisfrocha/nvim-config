return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {"williamboman/mason.nvim",config = function() require('mason').setup() end},
    cmd = { "DapInstall", "DapUninstall" },
    opts = function(_, opts)
      table.insert(opts.ensure_installed, {
        "bash-language-server",
        "cssmodules-language-server",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "emmet-language-server",
        "eslint_d",
        "eslint-lsp",
        "fixjson",
        "graphql-language-service-cli",
        "htmlbeautifier",
        "html-lsp",
        "intelephense",
        "isort",
        "jsonlint",
        "json-lsp",
        "js-debug-adapter",
        "luau-lsp",
        "lua-language-server",
        "markdownlint",
        "phpcbf",
        "phpcs",
        "phpstan",
        "php-cs-fixer",
        "php-debug-adapter",
        "prettier",
        "prettierd",
        "quick-lint-js",
        "shfmt",
        "sonarlint-language-server",
        "sql-formatter",
        "standardjs",
        "stylelint",
        "stylelint-lsp",
        "stylua",
        "tailwindcss-language-server",
        "typescript-language-server",
        "vtsls",
        "vue-language-server",
        "yamlfix",
        "yamlfmt",
        "yamllint",
        "yaml-language-server",
        "yq",
      })
      opts.automatic_installation = true
    end,
  },
}

