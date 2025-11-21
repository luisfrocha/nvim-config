local api = vim.api

-- Lint Javascript files
api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
  command = "silent! EslintFixAll",
  group = vim.api.nvim_create_augroup("MyAutocmdsJavaScripFormatting", {}),
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

-- Show project folder + relative path (remove " - Nvim")
api.nvim_create_autocmd({ "BufEnter", "BufNewFile", "BufRead", "DirChanged", "VimEnter" }, {
  callback = function()
    vim.schedule(function()
      local file = vim.fn.expand("%:t")                                -- filename
      if file ~= "" then
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t") -- project folder name
        local relative_path = vim.fn.expand("%:.")                     -- relative path from project root
        vim.o.titlestring = project_name .. "/" .. relative_path
      else
        -- No file open, just show project name
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        vim.o.titlestring = project_name
      end
    end)
  end,
  group = vim.api.nvim_create_augroup("ProjectPathTitle", { clear = true }),
})
