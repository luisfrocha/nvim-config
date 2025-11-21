return {
  "neovim/nvim-lspconfig",
  ft = { "html", "htmldjango", "css", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "elixir", "heex", "eex" },
  dependencies = {
    {
      "folke/neoconf.nvim",
      cmd = "Neoconf",
      opts = {},
    },
    "jose-elias-alvarez/typescript.nvim",
  },

  opts = {
    servers = {
      -- HTML Language Server with support for templates
      ["html-lsp"] = {
        filetypes = {
          "html",
          "elixir",
          "heex",
          "eex",
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

      -- CSS Language Server with Tailwind support
      ["css-lsp"] = {
        settings = {
          css = {
            lint = { unknownAtRules = "ignore" },
            validate = true,
          },
          scss = {
            lint = { unknownAtRules = "ignore" },
            validate = true,
          },
        },
      },

      -- Tailwind CSS Language Server
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
          "elixir",
          "heex",
          "eex",
        },
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                "class[:]\\s*\"([^\"]*)\"",
                "class[:]\\s*\"([^\"]*)\"",
                "~H\"\"\"[\\s\\S]*?class=\"([^\"]*)\"",
                'class="([^"]*)',
                "class: \"([^\"]*)\"",
              },
            },
          },
        },
      },

      dockerls = {},
      docker_compose_language_service = {},

      -- Elixir Language Server with comprehensive setup
      elixirls = {
        settings = {
          elixirLS = {
            -- Enable dialyzer for better type checking
            dialyzerEnabled = true,
            -- Enable formatting
            enableTestLenses = true,
            -- Suggest specs for functions
            suggestSpecs = true,
            -- Auto-import completion
            autoLinkedDeps = true,
            -- Project root patterns
            projectDir = ".",
          },
        },
        keys = {
          {
            "<leader>cp",
            function()
              local params = vim.lsp.util.make_position_params()
              require("snacks.util.lsp").execute({
                command = "manipulatePipes:serverid",
                arguments = {
                  "toPipe",
                  params.textDocument.uri,
                  params.position.line,
                  params.position.character,
                },
              })
            end,
            desc = "To Pipe",
            ft = "elixir",
          },
          {
            "<leader>cP",
            function()
              local params = vim.lsp.util.make_position_params()
              require("snacks.util.lsp").execute({
                command = "manipulatePipes:serverid",
                arguments = {
                  "fromPipe",
                  params.textDocument.uri,
                  params.position.line,
                  params.position.character,
                },
              })
            end,
            desc = "From Pipe",
            ft = "elixir",
          },
          {
            "<leader>ct",
            function()
              require("snacks.util.lsp").execute({
                command = "elixir.lens.test.run",
                arguments = { vim.uri_from_fname(vim.fn.expand("%:p")) },
              })
            end,
            desc = "Run Tests",
            ft = "elixir",
          },
        },
      },

      -- Vue Language Server for Vue and Nuxt
      volar = {
        filetypes = { "vue" },
        settings = {
          vue = {
            updateImportsOnFileMove = {
              enabled = true,
            },
            inlayHints = {
              missingProps = true,
              inlineHandlerLeading = true,
              vBindShorthand = true,
            },
            codeActions = {
              enabled = true,
            },
          },
          typescript = {
            updateImportsOnFileMove = {
              enabled = true,
            },
            suggest = {
              autoImports = true,
            },
            inlayHints = {
              enumMemberValues = {
                enabled = true,
              },
              functionLikeReturnTypes = {
                enabled = true,
              },
              parameterNames = {
                enabled = "literals",
              },
              parameterTypes = {
                enabled = true,
              },
              propertyDeclarationTypes = {
                enabled = true,
              },
              variableTypes = {
                enabled = false,
              },
            },
          },
        },
        keys = {
          {
            "<leader>co",
            "<cmd>TypescriptOrganizeImports<CR>",
            desc = "Organize Imports",
            ft = "vue",
          },
        },
      },

      -- ESLint for linting JavaScript/TypeScript/Vue
      ["eslint-lsp"] = {
        settings = {
          workingDirectory = { mode = "auto" },
          experimental = {
            useFlatConfig = true,
          },
        },
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
      },

      -- TypeScript Language Server
      vtsls = {
        settings = {
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              autoImports = true,
              completeFunctionCalls = true,
            },
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
            suggest = {
              autoImports = true,
              completeFunctionCalls = true,
            },
          },
        },
        keys = {
          {
            "<leader>co",
            "<cmd>TypescriptOrganizeImports<CR>",
            desc = "Organize Imports",
            ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
          },
          {
            "<leader>cR",
            "<cmd>TypescriptRenameFile<CR>",
            desc = "Rename File",
            ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
          },
          {
            "<leader>cA",
            "<cmd>TypescriptAddMissingImports<CR>",
            desc = "Add Missing Imports",
            ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
          },
        },
      },

      -- JSON Language Server
      jsonls = {
        settings = {
          json = {
            schemas = {
              {
                fileMatch = { "package.json" },
                url = "https://json.schemastore.org/package.json",
              },
              {
                fileMatch = { "tsconfig*.json" },
                url = "https://json.schemastore.org/tsconfig.json",
              },
              {
                fileMatch = { ".eslintrc", ".eslintrc.json" },
                url = "https://json.schemastore.org/eslintrc.json",
              },
            },
          },
        },
      },

      -- Emmet for HTML/CSS expansions
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
          "elixir",
          "heex",
          "eex",
        },
      },
    },

    -- Global LSP configuration that applies to all servers
    on_attach = function(client, buffer)
      -- ESLint formatting setup
      if client.name == "eslint-lsp" then
        client.server_capabilities.documentFormattingProvider = true
      elseif client.name == "tsserver" or client.name == "vtsls" then
        -- Disable formatting for TypeScript servers if ESLint is available
        client.server_capabilities.documentFormattingProvider = false
      elseif client.name == "elixirls" then
        -- Enable Elixir formatting
        client.server_capabilities.documentFormattingProvider = true
      elseif client.name == "volar" then
        -- Enable Vue formatting
        client.server_capabilities.documentFormattingProvider = true
      end

      -- Enable inlay hints if supported
      if client.supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
      end
    end,

    setup = {
      ["emmet-ls"] = function() end,

      -- Vue Language Server setup
      volar = function()
        -- Ensure proper Vue development experience
        return true
      end,
    },
  },
}
