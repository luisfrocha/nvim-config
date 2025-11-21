return {
  "neovim/nvim-lspconfig",
  ft = { "html", "htmldjango", "css", "javascript" },
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
      ["html-lsp"] = {
        filetypes = {
          "html",
          "elixir",
          "heex",
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

      ["css-lsp"] = {
        settings = { css = { lint = { unknownAtRules = "ignore" } } },
      },

      dockerls = {},
      docker_compose_language_service = {},

      elixirls = {
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
          },
        },
      },

      ["eslint-lsp"] = {},

      vtsls = {
        settings = {},
        keys = {
          {
            "<leader>co",
            "<cmd>TypescriptOrganizeImports<CR>",
            desc = "Organize Imports",
            ft = { "typescript", "typescriptreact" },
          },
          {
            "<leader>cR",
            "<cmd>TypescriptRenameFile<CR>",
            desc = "Rename File",
            ft = { "typescript", "typescriptreact" },
          },
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
      end
    end,

    setup = {
      ["emmet-ls"] = function() end,
    },
  },
}
