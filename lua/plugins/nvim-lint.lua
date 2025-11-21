return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Configure linters for different file types
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      vue = { "eslint_d" },
      elixir = { "credo" },
    }

    -- Custom linter for Elixir Credo
    lint.linters.credo = {
      name = "credo",
      cmd = "mix",
      stdin = false,
      args = { "credo", "suggest", "--format", "flycheck", "--read-from-stdin" },
      stream = "stdout",
      ignore_exitcode = true,
      parser = require("lint.parser").from_pattern(
        "^([^:]+):(%d+):?(%d*):? %(.-%): (.*)$",
        { "file", "lnum", "col", "message" },
        nil,
        {
          ["severity"] = vim.diagnostic.severity.INFO,
          ["source"] = "credo",
        }
      ),
    }

    -- Auto-lint on specific events
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        -- Only lint if the file type is supported
        local ft = vim.bo.filetype
        if lint.linters_by_ft[ft] then
          lint.try_lint()
        end
      end,
    })

    -- Manual lint command
    vim.keymap.set("n", "<leader>cl", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}