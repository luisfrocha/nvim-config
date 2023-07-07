-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.node_host_prog = "/Users/luisrocha/.nvm/versions/node/v18.16.0/bin:node"

vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
