-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Set terminal background to transparent
vim.cmd([[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]])
vim.o.guifont = "VictorMono Nerd Font,Hack Nerd Font:h16"
vim.g.transparent_enabled = true
