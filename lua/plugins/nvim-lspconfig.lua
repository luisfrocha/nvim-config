return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
  config = function()
    -- HTML
    vim.lsp.config("html", {
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
    })

    -- CSS / SCSS
    vim.lsp.config("cssls", {
      settings = {
        css = { lint = { unknownAtRules = "ignore" }, validate = true },
        scss = { lint = { unknownAtRules = "ignore" }, validate = true },
      },
    })

    -- Tailwind CSS
    vim.lsp.config("tailwindcss", {
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
    })

    -- Vue (Volar)
    vim.lsp.config("volar", {
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
    })

    -- TypeScript / JavaScript (vtsls)
    vim.lsp.config("vtsls", {
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
    })

    -- JSON
    vim.lsp.config("jsonls", {
      settings = {
        json = {
          schemas = {
            { fileMatch = { "package.json" }, url = "https://json.schemastore.org/package.json" },
            { fileMatch = { "tsconfig*.json" }, url = "https://json.schemastore.org/tsconfig.json" },
            { fileMatch = { ".eslintrc", ".eslintrc.json" }, url = "https://json.schemastore.org/eslintrc.json" },
          },
        },
      },
    })

    -- Emmet
    vim.lsp.config("emmet_ls", {
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
    })

    -- Custom server
    vim.lsp.config("expert", { settings = { workspaceSymbols = { minQueryLength = 0 } } })
    vim.lsp.enable("expert")

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
          return
        end
        -- Disable formatting for servers where conform handles it
        if client.name == "vtsls" or client.name == "volar" then
          client.server_capabilities.documentFormattingProvider = false
        end
        -- Enable inlay hints
        if client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
      end,
    })
  end,
}
