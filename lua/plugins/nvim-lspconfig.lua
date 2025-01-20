return {
  "neovim/nvim-lspconfig",
  ft = { "html", "htmldjango", "css" },
  dependencies = {
    "jose-elias-alvarez/typescript.nvim",
    init = function()
      require("lazyvim.util").lsp.on_attach(function(_, buffer)
        vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
        vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { buffer = buffer, desc = "Rename File" })
      end)
    end,
  },
  opts = {
    servers = {
      html = {
        filetypes = {
          "html",
          "htmldjango",
          "elixir",
          "heex",
          "eruby",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "rust",
          "svelte",
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
      cssls = { settings = { css = { lint = { unknownAtRules = "ignore" } } } },
      dockerls = {},
      docker_compose_language_service = {},
      elixirls = {
        keys = {
          {
            "<leader>cp",
            function()
              local params = vim.lsp.util.make_position_params()
              LazyVim.lsp.execute({
                command = "manipulatePipes:serverid",
                arguments = { "toPipe", params.textDocument.uri, params.position.line, params.position.character },
              })
            end,
            desc = "To Pipe",
          },
          {
            "<leader>cP",
            function()
              local params = vim.lsp.util.make_position_params()
              LazyVim.lsp.execute({
                command = "manipulatePipes:serverid",
                arguments = { "fromPipe", params.textDocument.uri, params.position.line, params.position.character },
              })
            end,
            desc = "From Pipe",
          },
        },
      },
      eslint = {},
      volar = {
        init_options = {
          vue = { hybridMode = true },
        },
      },
      vtsls = {
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {},
            },
          },
        },
      },
    },
    setup = {
      emmet_ls = {},
      eslint = function()
        require("lazyvim.util").lsp.on_attach(function(client)
          if client.name == "eslint" then
            client.server_capabilities.documentFormattingProvider = true
          elseif client.name == "tsserver" then
            client.server_capabilities.documentFormattingProvider = false
          end
        end)
      end,
    },
  },
}
