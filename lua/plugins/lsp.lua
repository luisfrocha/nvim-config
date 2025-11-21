return {
  -- Mason to manage LSP servers
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "lexical", -- Elixir LSP
        "erlangls", -- Erlang LSP
      })
    end,
  },
  -- LSP Configuration & Plugins
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lexical = {},
      },
      on_attach = function(client, buffer)
        require("snacks.util.lsp").on_attach(client, buffer)
        -- You can add custom keymaps here for LSP features
      end,
    },
  },
}
