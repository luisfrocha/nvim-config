return {
  {
    "neovim/nvim-lspconfig",
    ft = "graphql",
    opts = {
      servers = {
        graphql = {},
      },
    },
  },
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "graphql-language-service-cli" })
      else
        opts.ensure_installed = { "graphql-language-service-cli" }
      end
    end,
  },
}
