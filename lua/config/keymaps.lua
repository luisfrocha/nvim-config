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

map("n", "<leader>sx", require("telescope.builtin").resume, { noremap = true, silent = true, desc = "Resume" })

-- Move Lines
map("n", "<C-S-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<C-S-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<C-S-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<C-S-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<C-S-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<C-S-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
map({ "n", "i", "v" }, "<C-S-Y>", require("ts-node-action").node_action, { desc = "Trigger Node Action" })
map({ "n", "v" }, "<leader>bB", ":ls<cr>:buffer<space>", { desc = "Go to Buffer" })
map({ "n", "v" }, "<C-tab>", ":ls<cr>:buffer<space>", { desc = "Go to Buffer" })
map({ "n", "v", "x" }, "<C-BS>", '"_dd', { desc = "Delete line (not cut)" })
map({ "i" }, "<C-BS>", '<C-o>"_dd', { desc = "Delete line (not cut)" })
