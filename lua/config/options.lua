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

opt.winbar = "%=%m %f"
opt.relativenumber = false
opt.termguicolors = true
