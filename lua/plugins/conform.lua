return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = function(_, opts)
    vim.list_extend(opts.formatters_by_ft, {
      javascript = { "eslint_d", "prettierd" },
      typescript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescriptreact = { "prettierd" },
      svelte = { "prettierd" },
      css = { "prettierd" },
      html = { "prettierd" },
      json = { "prettierd" },
      jsonc = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      graphql = { "prettierd" },
      lua = { "stylua" },
      python = { "isort", "black" },
      elixir = { "mix" },
      heex = { "rustywind", "htmlbeautifier", "mix" },
      ["*"] = { "trim_newlines", "trim_whitespace" },
    })
    if LazyVim.has_extra("formatting.prettierd") then
      opts.formatters_by_ft = opts.formatters_by_ft or {}
    end

    -- Enable format on save for better development experience
    opts.format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    }
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
