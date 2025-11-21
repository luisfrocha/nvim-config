local opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- Better escape mapping
map({ "i", "v" }, "jk", "<Esc>", { desc = "Exit insert mode with jk" })

-- Clear highlights on search when pressing <Esc> in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Move selected line / block of text in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Fast saving
map("n", "<Leader>w", ":write!<CR>", opts)
map("n", "<Leader>q", ":q!<CR>", opts)

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Better text manipulation
map("v", "p", '"_dP', { desc = "Paste without yanking selection" })
map("v", "P", '"_dp', { desc = "Paste without yanking selection" })

-- Quick fix for common typos
map("n", "<leader>fq", function()
  vim.cmd([[%s/\<teh\>/the/gi]])
  vim.cmd([[%s/\<recieve\>/receive/gi]])
  vim.cmd([[%s/\<seperator\>/separator/gi]])
  vim.cmd([[%s/\<occured\>/occurred/gi]])
end, { desc = "Fix common typos" })

-- Move to start/end of line
map({ "n", "x", "o" }, "H", "^", opts)
map({ "n", "x", "o" }, "L", "g_", opts)

-- Better line join
map("n", "J", "mzJ`z", { desc = "Join lines and maintain cursor position" })

-- Better page up/down - keep cursor in middle
map("n", "<C-d>", "<C-d>zz", { desc = "Page down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page up and center" })

-- Better search - keep cursor in middle
map("n", "n", "nzzzv", { desc = "Next search result and center" })
map("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Map enter to ciw in normal mode
map("n", "<CR>", "ciw", opts)
map("n", "<BS>", "ci", opts)

-- search current buffer
-- map("n", "<C-f>", "<Leader>ss", opts)
map("n", "<C-S-F>", function()
  require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Global search current word" })
map("n", "<C-F>", function()
  require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>"), paths = vim.fn.expand("%") } })
end, { desc = "Search current word current file" })
map("v", "<C-S-F>", function()
  require("grug-far").with_visual_selection()
end, { desc = "Search current selection" })
map("v", "<C-F>", function()
  require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })
end, { desc = "Search current selection" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- ctrl + x to cut full line
map("n", "<C-x>", "dd", opts)

-- Move Lines
map("n", "<C-S-j>", "<cmd>m .+1<cr>==", { desc = "Move down", noremap = true, silent = true })
map("n", "<C-S-k>", "<cmd>m .-2<cr>==", { desc = "Move up", noremap = true, silent = true })
map("i", "<C-S-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down", noremap = true, silent = true })
map("i", "<C-S-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up", noremap = true, silent = true })
map("v", "<C-S-j>", ":m '>+1<cr>gv=gv", { desc = "Move down", noremap = true, silent = true })
map("v", "<C-S-k>", ":m '<-2<cr>gv=gv", { desc = "Move up", noremap = true, silent = true })

map({ "n", "v", "x" }, "<C-BS>", '"_dd<esc>', { desc = "Delete line (not cut)", noremap = true, silent = true })
map({ "i" }, "<C-BS>", '<C-o>"_dd<esc>', { desc = "Delete line (not cut)", noremap = true, silent = true })
map({ "i", "n", "x" }, "<Alt-BS>", '"_c', { desc = "Delete selected text", noremap = true, silent = true })
map({ "x" }, "<C-p>", '"0p', { desc = "Paste text without copying selection", noremap = true, silent = true })
map({ "n" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Show code actions menu", noremap = true, silent = true })
map({ "n", "i", "v", "s" }, "<C-d>", "<esc>Yp", { desc = "Copy line down" })
map({ "n", "i" }, "<C-Tab>", "<cmd>FzfLua buffers<cr>", { desc = "Open Buffer", noremap = true, silent = true })
-- map({ "n", "i" }, "<C-S-F>", "<leader>sr", { desc = "Global search", noremap = true, silent = true })
map(
  { "i", "v", "n", "s" },
  "<C-s>",
  "<cmd>wa<cr><esc>",
  { desc = "Save modified files", noremap = true, silent = true }
)
-- map({ "n" }, "<Leader>bd", "<cmd>bd<cr>", { desc = "Close buffer", noremap = true, silent = true })
map({ "n" }, "U", "<cmd>redo<cr>", { desc = "Redo last change", noremap = true, silent = true })
