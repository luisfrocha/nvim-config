local M = {}

local function get_system_background()
  local result = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null")
  return vim.trim(result) == "Dark" and "dark" or "light"
end

function M.cycle()
  local mode = vim.g.theme_mode or "dark"
  if mode == "dark" then
    mode = "light"
  elseif mode == "light" then
    mode = "system"
  else
    mode = "dark"
  end
  vim.g.theme_mode = mode
  vim.o.background = mode == "system" and get_system_background() or mode
  vim.notify("Appearance: " .. mode, vim.log.levels.INFO, { title = "Theme" })
end

function M.label()
  local mode = vim.g.theme_mode or "dark"
  if mode == "dark" then
    return " Dark"
  elseif mode == "light" then
    return " Light"
  else
    return " System"
  end
end

return M
