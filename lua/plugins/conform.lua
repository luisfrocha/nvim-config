return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      svelte = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      graphql = { "prettier" },
      liquid = { "prettier" },
      lua = { "stylua" },
      vue = { "prettier" },
    },
    format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    },
  },
  keys = {
    {
      "<leader>cp",
      function()
        local conform = require("conform")
        conform.format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
      end,
      mode = { "n", "v" },
      { desc = "Format file or range (in visual mode)" },
    },
  },
}
