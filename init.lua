-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.node_host_prog = "/Users/luisrocha/.nvm/versions/node/v18.16.0/bin:node"

-- Set terminal background to transparent
vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
if vim.g.neovide then
  vim.o.guifont = "VictorMono Nerd Font,Hack Nerd Font:h16"
  vim.opt.linespace = -5

  -- Helper function for transparency formatting
  local alpha = function()
    return string.format("%x", math.floor(255 * vim.g.transparency or 0.5))
  end
  -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
  vim.g.neovide_transparency = 0.0
  vim.g.transparency = 0.9
  vim.g.neovide_background_color = "#0f1117" .. alpha()

  vim.g.neovide_hide_mouse_when_typing = true

  vim.g.neovide_underline_automatic_scaling = true
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_input_macos_alt_is_meta = true
  -- vim.g.neovide_cursor_animation_length = 0.75
  -- vim.g.neovide_cursor_trail_size = 0.75
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_vfx_particle_lifetime = 3
  vim.g.neovide_cursor_vfx_particle_density = 35.0
end
