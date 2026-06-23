return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    local js_fts = { javascript = true, javascriptreact = true, typescript = true, typescriptreact = true, vue = true }
    local css_fts = { css = true, scss = true }

    lint.linters_by_ft = {
      elixir = { "credo" }, -- LazyVim's Elixir extra also configures this
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

    -- Pick oxlint or eslint_d based on which config exists in the project
    local function js_linter()
      local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
      if #vim.fs.find(".oxlintrc.json", { upward = true, path = dir }) > 0 then
        return "oxlint"
      end
      if
        #vim.fs.find({
          ".eslintrc",
          ".eslintrc.json",
          ".eslintrc.js",
          ".eslintrc.cjs",
          "eslint.config.js",
          "eslint.config.cjs",
          "eslint.config.mjs",
        }, { upward = true, path = dir }) > 0
      then
        return "eslint_d"
      end
      return "oxlint" -- default
    end

    -- Auto-lint on specific events
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        local ft = vim.bo.filetype
        if js_fts[ft] then
          lint.try_lint(js_linter())
        elseif css_fts[ft] then
          local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
          local has_stylelint = #vim.fs.find(
            { ".stylelintrc", ".stylelintrc.json", ".stylelintrc.js", ".stylelintrc.cjs", "stylelint.config.js" },
            { upward = true, path = dir }
          ) > 0
          if has_stylelint then
            lint.try_lint("stylelint")
          end
        elseif lint.linters_by_ft[ft] then
          lint.try_lint()
        end
      end,
    })

    -- Manual lint command
    vim.keymap.set("n", "<leader>cl", function()
      local ft = vim.bo.filetype
      if js_fts[ft] then
        lint.try_lint(js_linter())
      elseif css_fts[ft] then
        local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
        local has_stylelint = #vim.fs.find(
          { ".stylelintrc", ".stylelintrc.json", ".stylelintrc.js", ".stylelintrc.cjs", "stylelint.config.js" },
          { upward = true, path = dir }
        ) > 0
        if has_stylelint then
          lint.try_lint("stylelint")
        end
      else
        lint.try_lint()
      end
    end, { desc = "Trigger linting for current file" })
  end,
}
