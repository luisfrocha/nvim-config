local api = vim.api

-- Prevent vtsls, vue_ls, cssls, tailwindcss, and emmet_ls from overriding conform's formatter
api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if
      client
      and (
        client.name == "vtsls"
        or client.name == "vue_ls"
        or client.name == "cssls"
        or client.name == "tailwindcss"
        or client.name == "emmet_ls"
      )
    then
      client.server_capabilities.documentFormattingProvider = false
    end
  end,
})

-- Run stylelint --fix directly on the file after saving SCSS/CSS files.
-- conform's stdin-based stylelint has convergence issues with multi-pass fixes
-- (blank-line removal and indentation correction interfere across passes).
-- Running on the actual file and reloading the buffer is reliable.
local scss_fixing = false
api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.scss", "*.css" },
  callback = function()
    if scss_fixing then
      return
    end
    local filepath = vim.fn.expand("%:p")
    local dir = vim.fn.fnamemodify(filepath, ":h")
    local config = vim.fs.find(
      { ".stylelintrc", ".stylelintrc.json", ".stylelintrc.js", ".stylelintrc.cjs", "stylelint.config.js" },
      { upward = true, path = dir }
    )
    if #config == 0 then
      return
    end
    local root = vim.fs.find({ "package.json" }, { upward = true, path = dir })[1]
    local cwd = root and vim.fn.fnamemodify(root, ":h") or dir
    -- Use local binary directly — avoids npx startup overhead
    local bin = cwd .. "/node_modules/.bin/stylelint"
    if vim.fn.executable(bin) == 0 then
      return
    end
    local bufnr = vim.api.nvim_get_current_buf()
    scss_fixing = true
    vim.fn.jobstart({ bin, "--fix", "--cache", filepath }, {
      cwd = cwd,
      on_exit = function(_, code1)
        if code1 == 0 or code1 == 2 then
          vim.fn.jobstart({ bin, "--fix", "--cache", filepath }, {
            cwd = cwd,
            on_exit = function()
              scss_fixing = false
              vim.schedule(function()
                if vim.api.nvim_buf_is_valid(bufnr) then
                  vim.diagnostic.reset(nil, bufnr)
                  vim.api.nvim_buf_call(bufnr, function()
                    vim.cmd("checktime")
                  end)
                  vim.defer_fn(function()
                    if vim.api.nvim_buf_is_valid(bufnr) then
                      local ft = vim.bo[bufnr].filetype
                      if ft == "scss" or ft == "css" then
                        require("lint").try_lint("stylelint")
                      end
                    end
                  end, 200)
                end
              end)
            end,
          })
        else
          scss_fixing = false
        end
      end,
    })
  end,
})

-- Set file type for Vue files

-- Apply VSCode-like editor preferences
api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "json", "css", "scss", "html" },
  callback = function()
    -- Match VSCode tab settings
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true

    -- Match VSCode word wrap settings
    vim.opt_local.textwidth = 120
    vim.opt_local.colorcolumn = "120"

    -- Match VSCode bracket pair settings
    vim.opt_local.showmatch = true
  end,
})

-- Elixir-specific settings (matching your VSCode elixir config)
api.nvim_create_autocmd("FileType", {
  pattern = { "elixir", "heex", "eex" },
  callback = function()
    -- Match ElixirLS settings from VSCode
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true

    -- Enable Emmet for Elixir templates (matching your emmet.includeLanguages)
    vim.b.emmet_html5 = true
  end,
})

-- Remove insert-mode arrow key mappings added by the built-in SQL ftplugin;
-- they call sqlcomplete#DrillIntoTable/DrillOutOfColumns which fail in Neovim
api.nvim_create_autocmd("FileType", {
  pattern = "sql",
  callback = function()
    vim.keymap.del("i", "<Left>", { buffer = true })
    vim.keymap.del("i", "<Right>", { buffer = true })
  end,
})

-- Force treesitter for heex/eex — vim-elixir sets b:current_syntax at startup
-- which prevents treesitter from auto-starting on these filetypes
api.nvim_create_autocmd("FileType", {
  pattern = { "heex", "eex" },
  callback = function()
    vim.treesitter.start()
  end,
})

-- Show project folder + relative path (remove " - Nvim")
-- api.nvim_create_autocmd({ "BufEnter", "BufNewFile", "BufRead", "DirChanged", "VimEnter" }, {
--   callback = function()
--     vim.schedule(function()
--       local file = vim.fn.expand("%:t")                                -- filename
--       if file ~= "" then
--         local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t") -- project folder name
--         local relative_path = vim.fn.expand("%:.")                     -- relative path from project root
--         vim.o.titlestring = project_name .. "/" .. relative_path
--       else
--         -- No file open, just show project name
--         local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
--         vim.o.titlestring = project_name
--       end
--     end)
--   end,
--   group = vim.api.nvim_create_augroup("ProjectPathTitle", { clear = true }),
-- })
