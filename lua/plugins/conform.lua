return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = function(_, opts)
    vim.list_extend(opts.formatters_by_ft, {
      javascript = { "eslint_d", "prettier" },
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
      lua = { "stylua" },
      python = { "isort", "black" },
    })
    if LazyVim.has_extra("formatting.prettier") then
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.htmlangular = { "prettier" }
    end
    -- format_on_save = {
    --   lsp_fallback = true,
    --   async = false,
    --   timeout_ms = 1000,
    -- },
  end,
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
    -- {
    --   "<leader>cp",
    --   function()
    --     local conform = require("conform")
    --     conform.format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
    --   end,
    --   mode = "v",
    --   { desc = "Format file or range (in visual mode)" },
    -- },
  },
}
