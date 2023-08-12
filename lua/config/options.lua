-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local vim = vim
local opt = vim.opt

-- Enable mouse movements
opt.mousemoveevent = true

-- Wrap lines and indent
opt.linebreak = true
opt.wrap = true
opt.showbreak = "↳ "
opt.breakindent = true

opt.winblend = 30
opt.pumblend = 30

opt.winbar = "%=%m %f"
opt.relativenumber = false
opt.termguicolors = true
opt.guicursor =
  "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
vim.filetype.add({
  extension = {
    postcss = "css",
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
  command = "silent! EslintFixAll",
  group = vim.api.nvim_create_augroup("MyAutocmdsJavaScripFormatting", {}),
})
