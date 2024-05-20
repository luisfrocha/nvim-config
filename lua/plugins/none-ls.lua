return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "jay-babu/mason-null-ls.nvim",
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
      "gbprod/none-ls-shellcheck.nvim",
    },
    config = function()
      require("null-ls").register(require("none-ls-shellcheck.diagnostics"))
      require("null-ls").register(require("none-ls-shellcheck.code_actions"))

      local mason_null_ls = require("mason-null-ls")
      local null_ls = require("null-ls")

      local null_ls_utils = require("null-ls.utils")

      mason_null_ls.setup({
        ensure_installed = {
          "prettierd", -- prettier formatter
          "stylua", -- lua formatter
          "eslint_d", -- js linter
          "shellcheck", -- shell linter
          "yamllint", -- yaml linter
          "buf", -- buf formatter
          "shfmt", -- shell formatter
          "yamlfmt", -- yaml formatter
          "pretty_php", -- php formatter
          "rustywind", -- TailwindCSS organizer
          -- "spell", -- spell checker
          "vue-language-server", -- Vue formatter
        },
      })

      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      local code_actions = null_ls.builtins.code_actions

      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      null_ls.setup({
        root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),

        sources = {
          formatting.stylua,
          formatting.prettierd,
          -- formatting.gofumpt,
          formatting.buf,
          formatting.shfmt,
          formatting.yamlfmt,
          formatting.pretty_php,
          formatting.rustywind,

          -- diagnostics.eslint_d,
          -- diagnosticsueslint_d.with({ -- js/ts linter
          --   condition = function(utils)
          --     return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
          --   end,
          -- }),
          -- diagnostics.shellcheck,
          diagnostics.yamllint,

          code_actions.gitsigns,
          code_actions.refactoring,
        },
        -- configure format on save
        on_attach = function(current_client, bufnr)
          if current_client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  filter = function(client)
                    --  only use null-ls for formatting instead of lsp server
                    return client.name == "null-ls"
                  end,
                  bufnr = bufnr,
                })
              end,
            })
          end
        end,
      })
    end,
  },
}
