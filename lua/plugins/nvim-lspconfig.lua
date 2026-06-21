return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      html = {
        filetypes = {
          "html",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
        settings = {
          html = {
            format = {
              templating = true,
              wrapLineLength = 120,
              wrapAttributes = "auto",
            },
          },
        },
      },

      cssls = {
        settings = {
          css = { lint = { unknownAtRules = "ignore" }, validate = true },
          scss = { lint = { unknownAtRules = "ignore" }, validate = true },
        },
      },

      tailwindcss = {
        filetypes = {
          "html",
          "css",
          "scss",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                'class[:]\\s*"([^"]*)"',
                'class="([^"]*)',
                'class: "([^"]*)"',
              },
            },
          },
        },
      },

      -- Vue (Volar v2 — server name changed from "volar" to "vue_ls")
      vue_ls = {
        filetypes = { "vue" },
        settings = {
          vue = {
            updateImportsOnFileMove = { enabled = true },
            inlayHints = {
              missingProps = true,
              inlineHandlerLeading = true,
              vBindShorthand = true,
            },
            codeActions = { enabled = true },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = true },
            suggest = { autoImports = true },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
        },
      },

      -- TypeScript / JavaScript (vtsls) — vue filetype + plugin added by lang.vue extra
      vtsls = {
        settings = {
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { autoImports = true, completeFunctionCalls = true },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
          javascript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { autoImports = true, completeFunctionCalls = true },
          },
        },
      },

      jsonls = {
        settings = {
          json = {
            schemas = {
              { fileMatch = { "package.json" }, url = "https://json.schemastore.org/package.json" },
              { fileMatch = { "tsconfig*.json" }, url = "https://json.schemastore.org/tsconfig.json" },
              { fileMatch = { ".eslintrc", ".eslintrc.json" }, url = "https://json.schemastore.org/eslintrc.json" },
            },
          },
        },
      },

      emmet_ls = {
        filetypes = {
          "html",
          "css",
          "scss",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
      },

      -- Custom internal server — not in Mason, must be enabled directly
      expert = {
        mason = false,
        settings = { workspaceSymbols = { minQueryLength = 0 } },
      },
    },
  },
}
