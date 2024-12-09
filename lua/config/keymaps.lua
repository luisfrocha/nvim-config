local opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- Move selected line / block of text in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Fast saving
map("n", "<Leader>w", ":write!<CR>", opts)
map("n", "<Leader>q", ":q!<CR>", opts)

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- paste over currently selected text without yanking it
map("v", "p", '"_dp')
map("v", "P", '"_dP')

-- Move to start/end of line
map({ "n", "x", "o" }, "H", "^", opts)
map({ "n", "x", "o" }, "L", "g_", opts)

-- Map enter to ciw in normal mode
map("n", "<CR>", "ciw", opts)
map("n", "<BS>", "ci", opts)

-- search current buffer
map("n", "<C-f>", "<Leader>ss", opts)

map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- ctrl + x to cut full line
map("n", "<C-x>", "dd", opts)

-- Move Lines
-- map("n", "<C-S-j>", "<cmd>m .+1<cr>==", { desc = "Move down", noremap = true, silent = true })
-- map("n", "<C-S-k>", "<cmd>m .-2<cr>==", { desc = "Move up", noremap = true, silent = true })
-- map("i", "<C-S-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down", noremap = true, silent = true })
-- map("i", "<C-S-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up", noremap = true, silent = true })
-- map("v", "<C-S-j>", ":m '>+1<cr>gv=gv", { desc = "Move down", noremap = true, silent = true })
-- map("v", "<C-S-k>", ":m '<-2<cr>gv=gv", { desc = "Move up", noremap = true, silent = true })

map({ "n", "v", "x" }, "<C-BS>", '"_dd<esc>', { desc = "Delete line (not cut)", noremap = true, silent = true })
map({ "i" }, "<C-BS>", '<C-o>"_dd<esc>', { desc = "Delete line (not cut)", noremap = true, silent = true })
map({ "i", "n", "x" }, "<Alt-BS>", '"_c', { desc = "Delete selected text", noremap = true, silent = true })
map({ "x" }, "<C-p>", '"0p', { desc = "Paste text without copying selection", noremap = true, silent = true })
map({ "n" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Show code actions menu", noremap = true, silent = true })
map({ "n", "i", "v", "s" }, "<C-d>", "<esc>Yp", { desc = "Copy line down" })
map(
  { "n", "i" },
  "<C-Tab>",
  ":lua require('telescope.builtin').buffers({sort_lastused=true,ignore_current_buffer=true})<cr>a",
  { desc = "Open Buffer", noremap = true, silent = true }
)
map({ "n", "i" }, "<C-S-F>", "<cmd>Telescope live_grep<cr>", { desc = "Global search", noremap = true, silent = true })
map(
  { "i", "v", "n", "s" },
  "<C-s>",
  "<cmd>wa<cr><esc>",
  { desc = "Save modified files", noremap = true, silent = true }
)
map({ "n" }, "<Leader>bd", "<cmd>bd<cr>", { desc = "Close buffer", noremap = true, silent = true })
map({ "n" }, "U", "<cmd>redo<cr>", { desc = "Redo last change", noremap = true, silent = true })
