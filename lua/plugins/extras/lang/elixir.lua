-- Enhanced Elixir configuration using elixir-tools (NextLS + modern tooling)
return {
  "neovim/nvim-lspconfig",

  dependencies = {
    {
      "elixir-tools/elixir-tools.nvim",
      version = "*",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        local elixir = require("elixir")
        local elixirls = require("elixir.elixirls")

        elixir.setup({
          nextls = {
            enable = true, -- Use NextLS (modern Elixir language server)
            init_options = {
              mix_env = "dev",
              mix_target = "host",
              experimental = {
                completions = { enable = true },
              },
            },
            on_attach = function(client, buffer)
              -- Elixir-specific keymaps
              vim.keymap.set("n", "<leader>cp", function()
                vim.lsp.buf.execute_command({
                  command = "nextls:toPipe",
                  arguments = { vim.uri_from_bufnr(buffer) },
                })
              end, { buffer = buffer, desc = "To Pipe" })

              vim.keymap.set("n", "<leader>cP", function()
                vim.lsp.buf.execute_command({
                  command = "nextls:fromPipe",
                  arguments = { vim.uri_from_bufnr(buffer) },
                })
              end, { buffer = buffer, desc = "From Pipe" })

              vim.keymap.set("n", "<leader>ct", function()
                vim.lsp.buf.execute_command({
                  command = "nextls:test",
                  arguments = { vim.uri_from_bufnr(buffer) },
                })
              end, { buffer = buffer, desc = "Run Tests" })
            end,
          },

          credo = {
            enable = true, -- Enable Credo for linting
            on_attach = function(client, buffer)
              vim.keymap.set("n", "<leader>cc", function()
                vim.cmd("!mix credo")
              end, { buffer = buffer, desc = "Run Credo" })
            end,
          },

          elixirls = {
            enable = false, -- Disable ElixirLS in favor of NextLS
          },
        })
      end,
    },
    "nvim-lua/plenary.nvim",
    "elixir-editors/vim-elixir", -- Syntax highlighting
  },

  opts = {
    servers = {
      -- HTML Language Server with Elixir template support
      ["html-lsp"] = {
        filetypes = {
          "html",
          "elixir",
          "heex",
          "eex",
          "surface",
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

      -- Tailwind CSS with Elixir template support
      tailwindcss = {
        filetypes = {
          "elixir",
          "heex",
          "eex",
          "html",
          "css",
          "scss",
        },
        init_options = {
          userLanguages = {
            elixir = "phoenix-heex",
            eruby = "erb",
            heex = "phoenix-heex",
            svelte = "html",
          },
        },
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                -- Phoenix LiveView patterns
                'class[:]?\\s*"([^"]*)',
                '~H"""[\\s\\S]*?class="([^"]*)"',
                'assign\\([^,]*,\\s*class:\\s*"([^"]*)"',
                -- Standard patterns
                'class="([^"]*)',
                "class='([^']*)",
              },
            },
          },
        },
      },

      -- Emmet for templates
      emmet_ls = {
        filetypes = {
          "html",
          "css",
          "scss",
          "elixir",
          "heex",
          "eex",
        },
      },
    },

    on_attach = function(client, buffer)
      -- Specific handling for NextLS
      if client.name == "nextls" then
        -- Enable formatting for Elixir files
        client.server_capabilities.documentFormattingProvider = true

        -- Enable inlay hints if supported
        if client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
        end
      end
    end,
  },
}
