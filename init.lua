require("config.keymaps")
require("config.options")
require("config.autocmds")
require("config.abbreviations")
require("config.lazy")

vim.g.loaded_matchit = 1
-- Set terminal background to transparent
vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
vim.o.guifont = "VictorMono Nerd Font,Hack Nerd Font:h16"
vim.g.transparent_enabled = true
