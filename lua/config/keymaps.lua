local opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- Move selected line / block of text in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Fast saving
map("n", "<Leader>w", ":write!<CR>", opts)
map("n", "<Leader>q", ":q!<CR>", opts)

-- Remap for dealing with visual line wraps
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- paste over currently selected text without yanking it
map("v", "p", '"_dp')
map("v", "P", '"_dP')

-- copy everything between { and } including the brackets
-- p puts text after the cursor,
-- P puts text before the cursor.
map("n", "YY", "va{Vy", opts)

-- Move line on the screen rather than by line in the file
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)

-- Exit on jj and jk
map("i", "jj", "<ESC>", opts)
map("i", "jk", "<ESC>", opts)

-- Move to start/end of line
map({ "n", "x", "o" }, "H", "^", opts)
map({ "n", "x", "o" }, "L", "g_", opts)

-- Navigate buffers
map("n", "<M-Right>", ":bnext<CR>", opts)
map("n", "<M-Left>", ":bprevious<CR>", opts)

-- Panes resizing
map("n", "+", ":vertical resize +5<CR>")
map("n", "_", ":vertical resize -5<CR>")
map("n", "=", ":resize +5<CR>")
map("n", "-", ":resize -5<CR>")

-- Map enter to ciw in normal mode
map("n", "<CR>", "ciw", opts)
map("n", "<BS>", "ci", opts)

-- map("n", "n", "nzzv", opts)
-- map("n", "N", "Nzzv", opts)
map("n", "*", "*zzv", opts)
map("n", "#", "#zzv", opts)
map("n", "g*", "g*zz", opts)
map("n", "g#", "g#zz", opts)

-- map ; to resume last search
-- map("n", ";", "<cmd>Telescope resume<cr>", opts)

-- search current buffer
map("n", "<C-f>", "<Leader>ss", opts)

-- search modified files
map("n", "<Leader>m", ":Telescope git_status<CR>", opts)

-- Split line with X
map("n", "X", ":keeppatterns substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==^<cr>", { silent = true })

-- Select all
map("n", "<C-a>", "ggVG", opts)

-- write file in current directory
-- :w %:h/<new-file-name>
map("n", "<C-n>", ":w %:h/", opts)

-- delete forward
-- w{number}dw
-- delete backward
-- w{number}db

map("n", "<C-P>", ':lua require("config.utils").toggle_go_test()<CR>', opts)

map("n", "<Esc>", ":nohlsearch<CR>", opts)

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
