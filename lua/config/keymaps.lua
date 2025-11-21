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

map({ "n" }, "<C-F>", ":SearchBoxMatchAll show_matches=true<cr>", { desc = "Search in Buffer" })
map({ "x" }, "<C-f>", "<esc>:SearchBoxMatchAll show_matches=true<cr>", { desc = "Search in Buffer" })
map({ "n" }, "<C-r>", ":SearchBoxReplace show_matches=true confirm=menu<cr>", { desc = "Search & Replace in Buffer" })
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>wa<cr><esc>", { desc = "Save modified files" })
map({ "i", "v", "n", "s" }, "<C-d>", "<esc>Yp", { desc = "Copy line down" })
map({ "n" }, "U", "<cmd>redo<cr>", { desc = "Redo last change", noremap = true })
map("x", "p", "P", { silent = true, noremap = true })
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
