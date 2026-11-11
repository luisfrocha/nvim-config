return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = function(_, opts)
    -- Dynamically pick formatter based on which config exists in the project root
    local function js_formatter(bufnr)
      local filepath = vim.api.nvim_buf_get_name(bufnr)
      local dir = vim.fn.fnamemodify(filepath, ":h")
      if #vim.fs.find(".oxfmtrc.json", { upward = true, path = dir }) > 0 then
        return { "oxfmt" }
      end
      if
        #vim.fs.find(
          { ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.cjs", "prettier.config.js" },
          { upward = true, path = dir }
        ) > 0
      then
        return { "prettier" }
      end
      return { "oxfmt" }
    end

    local function style_formatter(bufnr)
      local filepath = vim.api.nvim_buf_get_name(bufnr)
      local dir = vim.fn.fnamemodify(filepath, ":h")
      if #vim.fs.find(".oxfmtrc.json", { upward = true, path = dir }) > 0 then
        return { "oxfmt" }
      end
      return { "prettier" }
    end

    local function scss_formatter(bufnr)
      local filepath = vim.api.nvim_buf_get_name(bufnr)
      local dir = vim.fn.fnamemodify(filepath, ":h")
      if
        #vim.fs.find(
          { ".stylelintrc", ".stylelintrc.json", ".stylelintrc.js", ".stylelintrc.cjs", "stylelint.config.js" },
          { upward = true, path = dir }
        ) > 0
      then
        return { "scss_combinator_fix" }
      end
      return { "prettier" }
    end

    opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
      javascript = js_formatter,
      typescript = js_formatter,
      javascriptreact = js_formatter,
      typescriptreact = js_formatter,
      vue = js_formatter,
      svelte = js_formatter,
      css = style_formatter,
      scss = scss_formatter,
      html = style_formatter,
      json = js_formatter,
      jsonc = js_formatter,
      yaml = js_formatter,
      markdown = js_formatter,
      graphql = js_formatter,

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

    -- Custom formatters configuration (matching your VSCode settings)
    opts.formatters = opts.formatters or {}

    -- Fixes `>selector` → `> selector` in SCSS nested combinators.
    -- stylelint's selector-combinator-space-after doesn't handle leading
    -- combinators in SCSS nesting, so we do it with a targeted perl regex.
    opts.formatters.scss_combinator_fix = {
      command = "perl",
      args = { "-pe", "s/^(\\s*)>([^ >\\n])/$1> $2/g" },
      stdin = true,
    }

    -- Mix formatter with proper project root detection
    opts.formatters.mix = {
      command = "mix",
      args = { "format", "-" },
      stdin = true,
      cwd = require("conform.util").root_file({ "mix.exs" }),
    }

    -- Oxfmt reads .oxfmtrc.json — must run from project root to find it
    opts.formatters.oxfmt = {
      command = "oxfmt",
      args = { "--stdin-filepath", "$FILENAME" },
      stdin = true,
      cwd = require("conform.util").root_file({ ".oxfmtrc.json", "package.json", ".git" }),
    }
  end,
  keys = {
    {
      "<leader>cp",
      function()
        local conform = require("conform")
        conform.format({ lsp_format = "fallback", async = false, timeout_ms = 1000 })
      end,
      mode = { "n", "v" },
      { desc = "Format file or range (in visual mode)" },
    },
    {
      "<leader>cO",
      function()
        local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
        local found = vim.fs.find(
          { ".prettierrc", ".prettierrc.json", ".prettierrc.js", "package.json", ".git" },
          { upward = true, path = dir }
        )
        if #found == 0 then
          vim.notify("oxfmt migrate: no project root found", vim.log.levels.WARN)
          return
        end
        local cwd = vim.fn.fnamemodify(found[1], ":h")
        vim.fn.jobstart({ "oxfmt", "--migrate=prettier" }, {
          cwd = cwd,
          on_stderr = function(_, data)
            if data and #data > 0 and data[1] ~= "" then
              vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
            end
          end,
          on_exit = function(_, code)
            if code ~= 0 then
              vim.notify("oxfmt migrate failed (exit " .. code .. ")", vim.log.levels.ERROR)
              return
            end
            local prettier_files = {
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.js",
              ".prettierrc.cjs",
              ".prettierrc.mjs",
              ".prettierrc.yaml",
              ".prettierrc.yml",
              ".prettierrc.toml",
              "prettier.config.js",
              "prettier.config.cjs",
              "prettier.config.mjs",
              ".prettierignore",
            }
            local deleted = {}
            for _, name in ipairs(prettier_files) do
              local path = cwd .. "/" .. name
              if vim.fn.filereadable(path) == 1 then
                vim.fn.delete(path)
                table.insert(deleted, name)
              end
            end
            local msg = "oxfmt: created .oxfmtrc.json in " .. cwd
            if #deleted > 0 then
              msg = msg .. "\nDeleted: " .. table.concat(deleted, ", ")
            end
            vim.notify(msg, vim.log.levels.INFO)
          end,
        })
      end,
      desc = "Migrate .prettierrc → .oxfmtrc.json (and delete prettier files)",
    },
  },
}
