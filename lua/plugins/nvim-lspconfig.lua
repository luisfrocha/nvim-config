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
    init = function()
      require("lazyvim.util").lsp.on_attach(function(_, buffer)
        vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
        vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { buffer = buffer, desc = "Rename File" })
      end)
    end,
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
      ["css-lsp"] = { settings = { css = { lint = { unknownAtRules = "ignore" } } } },
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
      ["eslint-lsp"] = {},
      vtsls = {
        settings = {},
      },
    },
    setup = {
      ["emmet-ls"] = function() end,
      ["eslint-lsp"] = function()
        require("lazyvim.util").lsp.on_attach(function(client)
          if client.name == "eslint-lsp" then
            client.server_capabilities.documentFormattingProvider = true
          elseif client.name == "tsserver" then
            client.server_capabilities.documentFormattingProvider = false
          end
        end)
      end,
    },
  },
}
