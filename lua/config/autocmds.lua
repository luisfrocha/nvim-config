local api = vim.api

-- Lint Javascript files
api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
  command = "silent! EslintFixAll",
  group = vim.api.nvim_create_augroup("MyAutocmdsJavaScripFormatting", {}),
})

-- Set file type for Vue files
