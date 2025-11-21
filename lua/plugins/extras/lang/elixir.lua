-- File: plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",

  dependencies = {
    "elixir-tools/elixir-tools.nvim",
    "nvim-lua/plenary.nvim",
    "elixir-editors/vim-elixir",

    -- TypeScript (vtsls only)
    { "yioneko/nvim-vtsls" },
  },

  opts = {
    -- ---------------------------------------------------------
    -- LSP SERVER DEFINITIONS
    -- ---------------------------------------------------------
    servers = {

      -- HTML
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

      -- CSS
      ["css-lsp"] = {
        settings = {
          css = { lint = { unknownAtRules = "ignore" } },
        },
      },

      dockerls = {},
      docker_compose_language_service = {},

      -- ESLINT
      ["eslint-lsp"] = {},

      -- TypeScript (vtsls replaces tsserver completely)
      vtsls = {
        settings = {
          typescript = {
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = true },
            },
          },
        },
      },
    },

    -- ---------------------------------------------------------
    -- CUSTOM SERVER SETUP OVERRIDES
    -- ---------------------------------------------------------
    setup = {
      -- Do NOT load the old Emmet one
      ["emmet-ls"] = function() end,

      ["eslint-lsp"] = function()
        local lsp = require("snacks.util.lsp")
        lsp.on(function(client)
          if client.name == "eslint-lsp" then
            client.server_capabilities.documentFormattingProvider = true
          elseif client.name == "tsserver" then
            -- vtsls replaces tsserver, but this guards against fallback
            client.server_capabilities.documentFormattingProvider = false
          end
        end)
        return true
      end,
    },
  },

  -- ---------------------------------------------------------
  -- EXTRA CONFIG FOR TYPESCRIPT KEYMAPS + ELIXIR TOOLS
  -- ---------------------------------------------------------
  config = function(_, opts)
    local lsp = require("snacks.util.lsp")

    --------------------------------------------------------------------
    -- TYPESCRIPT KEYMAPS (vtsls)
    --------------------------------------------------------------------
    lsp.on(function(client, buffer)
      if client.name == "vtsls" then
        vim.keymap.set("n", "<leader>co", function()
          client.request("workspace/executeCommand", {
            command = "typescript.organizeImports",
            arguments = { vim.api.nvim_buf_get_name(buffer) },
          })
        end, { buffer = buffer, desc = "Organize Imports (vtsls)" })

        vim.keymap.set("n", "<leader>cR", function()
          client.request("workspace/executeCommand", {
            command = "typescript.renameFile",
            arguments = {
              vim.api.nvim_buf_get_name(buffer),
              vim.fn.input("New path: "),
            },
          })
        end, { buffer = buffer, desc = "Rename File (vtsls)" })
      end
    end)

    --------------------------------------------------------------------
    -- ELIXIR-TOOLS SETUP
    --------------------------------------------------------------------
    require("elixir").setup({
      credo = { enable = true },

      elixirls = { enable = false }, -- disable old LSP

      nextls = {
        enable = true,
        init_options = {
          experimental = {
            completions = { enable = true },
          },
          extensions = {
            credo = { enable = true },
            elixir = { enable = true },
          },
        },
      },
    })

    --------------------------------------------------------------------
    -- PASS OPTIONS TO LSPCONFIG
    --------------------------------------------------------------------
    require("lspconfig") -- ensure loaded
    require("lazyvim.plugins.lsp").setup(opts)
  end,
}
