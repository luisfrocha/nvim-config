-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Set terminal background to transparent
vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
vim.o.guifont = "VictorMono Nerd Font,Hack Nerd Font:h16"
vim.g.transparent_enabled = true
