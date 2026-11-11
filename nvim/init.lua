-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- Set terminal background to transparent
vim.cmd([[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]])
vim.o.guifont = "Victor Mono,Hack Nerd Font:h16:i"
vim.g.transparent_enabled = true

if vim.g.neovide then
  vim.g.neovide_opacity = 0.9
  vim.opt.linespace = -4
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_underline_automatic_scaling = true
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_input_macos_option_is_meta = true
  vim.g.neovide_cursor_trail_size = 1
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_vfx_particle_lifetime = 1
  vim.g.neovide_cursor_vfx_particle_density = 19.0
end
