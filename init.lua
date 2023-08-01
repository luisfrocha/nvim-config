-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.node_host_prog = "/Users/luisrocha/.nvm/versions/node/v18.16.0/bin:node"

-- Set terminal background to transparent
vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])

-- Set folds and open on file/buffer open
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- local M = {}
-- -- function to create a list of commands and convert them to autocommands
-- -------- This function is taken from https://github.com/norcalli/nvim_utils
-- function M.nvim_create_augroups(definitions)
--   for group_name, definition in pairs(definitions) do
--     api.nvim_command("augroup " .. group_name)
--     api.nvim_command("autocmd!")
--     for _, def in ipairs(definition) do
--       local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
--       api.nvim_command(command)
--     end
--     api.nvim_command("augroup END")
--   end
-- end
--
-- local autoCommands = {
--   -- other autocommands
--   open_folds = {
--     { "BufReadPost,FileReadPost", "*", "normal zR" },
--   },
-- }
--
-- M.nvim_create_augroups(autoCommands)
