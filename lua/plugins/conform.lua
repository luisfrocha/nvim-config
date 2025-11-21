return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = function(_, opts)
    vim.list_extend(opts.formatters_by_ft, {
      -- JavaScript/TypeScript with ESLint and Prettier
      javascript = { "eslint_d", "prettierd" },
      typescript = { "eslint_d", "prettierd" },
      javascriptreact = { "eslint_d", "prettierd" },
      typescriptreact = { "eslint_d", "prettierd" },

      -- Vue and Nuxt formatting
      vue = { "eslint_d", "prettierd" },

      -- Web technologies
      svelte = { "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
      html = { "prettierd" },
      json = { "prettierd" },
      jsonc = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      graphql = { "prettierd" },

      -- Languages
      lua = { "stylua" },
      python = { "isort", "black" },

      -- Elixir formatting
      elixir = { "mix" },
      heex = { "mix" },
      eex = { "mix" },

      -- Fallback for all files
      ["*"] = { "trim_newlines", "trim_whitespace" },
    })

    -- Custom formatters configuration
    opts.formatters = opts.formatters or {}
    opts.formatters.mix = {
      command = "mix",
      args = { "format", "-" },
      stdin = true,
    }

    if LazyVim.has_extra("formatting.prettierd") then
      opts.formatters_by_ft = opts.formatters_by_ft or {}
    end
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
