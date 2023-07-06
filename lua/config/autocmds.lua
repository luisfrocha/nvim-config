-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  group = vim.api.nvim_create_augroup("lazyvim_autostart_session", { clear = true }),
  callback = function()
    require("persistence").load()
  end,
})

vim.api.nvim_command("autocmd BufReadPost,BufNewFile *.vue setlocal filetype=vue")
