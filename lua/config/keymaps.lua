-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- Resize window using <ctrl> arrow keys
map("n", "<C-S-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
-- Move Lines
map("n", "<C-S-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<C-S-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<C-S-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<C-S-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<C-S-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<C-S-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

map({ "n", "v", "x" }, "<C-BS>", '"_dd<esc>', { desc = "Delete line (not cut)" })
map({ "i" }, "<C-BS>", '<C-o>"_dd<esc>', { desc = "Delete line (not cut)" })
-- map({ "n" }, "<C-.>", ":Lspsaga code_action<cr>", { desc = "Show code actions menu" })
map({ "i", "n", "x" }, "<Alt-BS>", '"_c', { desc = "Delete selected text" })
map({ "x" }, "<C-p>", '"0p', { desc = "Paste text without copying selection" })

-- map({ "n" }, "<C-S-F>", ":Spectre :initial_mode='insert'<cr>", { desc = "Global search" })
-- map({ "i" }, "<C-S-F>", "<esc>:Spectre :initial_mode='insert'<cr>", { desc = "Global search" })

map({ "n" }, "<C-F>", ":SearchBoxMatchAll show_matches=true<cr>", { desc = "Search in Buffer" })
map({ "x" }, "<C-f>", "<esc>:SearchBoxMatchAll show_matches=true<cr>", { desc = "Search in Buffer" })
map({ "n" }, "<C-r>", ":SearchBoxReplace show_matches=true confirm=menu<cr>", { desc = "Search & Replace in Buffer" })
-- map(
--   { "x" },
--   "<C-r>",
--   "<esc>:SearchBoxReplace show_matches=true confirm=menu<cr>",
--   { desc = "Search & Replace in Buffer" }
-- )
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>wa<cr><esc>", { desc = "Save modified files" })
map({ "i", "v", "n", "s" }, "<C-d>", "<esc>Yp", { desc = "Copy line down" })
map({ "n" }, "U", "<cmd>redo<cr>", { desc = "Redo last change", noremap = true })
map("x", "p", "P", { silent = true, noremap = true })

-- Buffman enhancements
function removePathFromFullPath(fullPath, pathToRemove)
  -- Replace backslashes with forward slashes for platform independence
  fullPath = fullPath:gsub("\\", "/")
  pathToRemove = pathToRemove:gsub("\\", "/")

  -- Normalize paths by removing trailing slashes
  fullPath = fullPath:gsub("/$", "")
  pathToRemove = pathToRemove:gsub("/$", "")

  local fullPathLen = #fullPath
  local pathToRemoveLen = #pathToRemove

  local i = 1
  while i <= fullPathLen and i <= pathToRemoveLen do
    if fullPath:sub(i, i) == pathToRemove:sub(i, i) then
      i = i + 1
    else
      break
    end
  end

  if i > pathToRemoveLen then
    -- Remove pathToRemove and any leading slash
    return fullPath:sub(i + 1)
  else
    return fullPath
  end
end

-- Function to open the buffer list window in order of usage with the first and second buffers swapped
function OpenBufferListWindow()
  -- Use vim.fn.execute to capture the output of ":ls t"
  local buffer_list = vim.fn.execute("ls t")

  -- Split the buffer list into lines
  local buf_names = vim.split(buffer_list, "\n")

  -- Remove the first line (header)
  table.remove(buf_names, 1)

  -- Check if there are at least two buffers
  if #buf_names >= 2 then
    -- Swap the first and second buffers
    local temp = buf_names[1]
    buf_names[1] = buf_names[2]
    buf_names[2] = temp
  end

  local cwdpath = vim.fn.getcwd():gsub("%~", vim.fn.expand("$HOME")):gsub("\\", "/")

  local path1 = cwdpath
  local path2 = ""

  -- Extract the buffer names within double quotes
  local buffer_names = {}
  for _, line in ipairs(buf_names) do
    local name = line:match('"([^"]+)"')
    local buf_number = line:match("([%d]+)")
    if name then
      local myname = name:gsub("%~", vim.fn.expand("$HOME")):gsub("\\", "/")

      path2 = myname

      -- print(path1, path2)

      local remainingPath = removePathFromFullPath(path2, path1)
      -- print(remainingPath)

      table.insert(buffer_names, buf_number .. "\t " .. remainingPath)
    end
  end

  vim.ui.select(buffer_names, {
    prompt = "Navigate to a Buffer",
  }, function(selected)
    if selected ~= "" and selected ~= nil then
      local buf_number = selected:match("([%d]+)")
      vim.cmd("buffer " .. buf_number)
    end
  end)
end

-- Set the keybinding to toggle the buffer list window
vim.api.nvim_set_keymap(
  "n",
  "<C-Tab>",
  ":lua require('telescope.builtin').buffers({sort_lastused=true,ignore_current_buffer=true})<cr>",
  { noremap = true, silent = true, desc = "Open Buffer List Window" }
)
map(
  { "i" },
  "<C-Tab>",
  ":lua require('telescope.builtin').buffers({sort_lastused=true,ignore_current_buffer=true})<cr>",
  { noremap = true, silent = true, desc = "Open Buffer List Window" }
)
