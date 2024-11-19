return {
  mode = { "n", "v" },
  { "<leader>;", ":Alpha<CR>", desc = "Dashboard" },
  { "<leader>w", ":w!<CR>", desc = "Save" },
  { "<leader>q", ":confirm q<CR>", desc = "Quit" },
  {
    "<leader>f",
    function()
      require("config.utils").telescope_git_or_file()
    end,
    desc = "Find Files (Root)",
  },
  { "<leader>b", group = "Buffers" },
  { "<leader>bd", "<cmd>bd<CR>", desc = "Close buffer" },
  {
    "<leader>bo",
    function()
      require("telescope.builtin").buffers()
    end,
    desc = "Open Buffer",
  },

  { "<leader>W", "<cmd>noautocmd w<cr>", desc = "Save without formatting (noautocmd)" },

  { "<leader>u", group = "UI" },
  { "<leader>uv", require("config.utils").toggle_set_color_column, desc = "Toggle Color Line" },
  { "<leader>uc", require("config.utils").toggle_cursor_line, desc = "Toggle Cursor Line" },
  {
    '<leader>uh',
    function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({0},{0}))
    end,
    desc = 'Toggle Inlay Hints'
  },

  { "<leader>i", group = "Sessions" },
  { "<leader>is", "<cmd>lua require('persistence').load()<cr>", desc = "Load Session" },
  { "<leader>il", "<cmd>lua require('persistence').load({ last = true })<cr>", desc = "Load Last Session" },
  { "<leader>id", "<cmd>lua require('persistence').stop()<cr>", desc = "Stop Persistence" },

  { "<leader>r", group = "Replace (Spectre)" },
  { "<leader>rr", "<cmd>lua require('spectre').open()<cr>", desc = "Replace" },
  { "<leader>rw", "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", desc = "Replace Word" },
  { "<leader>rf", "<cmd>lua require('spectre').open_file_search()<cr>", desc = "Replace Buffer" },

  { "<leader>G", group = "+Git" },
  { "<leader>Gk", "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message=false})<CR>", desc = "Prev Hunk" },
  { "<leader>Gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame" },
  { "<leader>Gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk" },
  { "<leader>Gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },
  { "<leader>GR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
  { "<leader>Gj", "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", desc = "Next Hunk" },
  { "<leader>Gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk" },
  { "<leader>Gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk" },
  { "<leader>Go", require("telescope.builtin").git_status, desc = "Open changed file" },
  { "<leader>Gb", require("telescope.builtin").git_branches, desc = "Checkout branch" },
  { "<leader>Gc", require("telescope.builtin").git_commits, desc = "Checkout commit" },
  { "<leader>GC", require("telescope.builtin").git_bcommits, desc = "Checkout commit(for current file)" },
  { "<leader>Gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Git Diff" },
  { "<leader>GU", ":UndotreeToggle<CR>", desc = "Toggle UndoTree" },

  { "<leader>l", group = "+LSP" },
  { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
  { "<leader>lA", vim.lsp.buf.range_code_action, desc = "Range Code Actions" },
  { "<leader>ls", vim.lsp.buf.signature_help, desc = "Display Signature Information" },
  { "<leader>lr", vim.lsp.buf.rename, desc = "Rename all references" },
  { "<leader>lf", vim.lsp.buf.format, desc = "Format" },
  { "<leader>li", require("telescope.builtin").lsp_implementations, desc = "Implementation" },
  { "<leader>ll", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
  { "<leader>lL", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
  { "<leader>lw", require("telescope.builtin").diagnostics, desc = "Diagnostics" },
  -- { "<leader>lt", require("telescope").extensions.refactoring.refactors, desc = "Refactor" },
  { "<leader>lc", require("config.utils").copyFilePathAndLineNumber, desc = "Copy File Path and Line Number" },
  { "<leader>lz", "<cmd>Lazy<cr>", desc = "Lazy Package Manager" },

  { "<leader>lW", group = "+Workspace" },
  { "<leader>lWa", vim.lsp.buf.add_workspace_folder, desc = "Add Folder" },
  { "<leader>lWr", vim.lsp.buf.remove_workspace_folder, desc = "Remove Folder" },
  {
    "<leader>lWl",
    function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,
    desc = "List Folders",
  },
  { "<leader>lg", "<cmd>lazygit<cr>", desc = "Lazy Git" },

  { "<leader>s", group = "+Search" },
  { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find File (CWD)" },
  { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Find Help" },
  { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Find highlight groups" },
  { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
  { "<leader>so", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
  { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
  { "<leader>st", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
  { "<leader>sT", "<cmd>Telescope grep_string<cr>", desc = "Grep String" },
  { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
  { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
  { "<leader>sl", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
  { "<leader>sc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
  { "<leader>sB", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
  { "<leader>sm", "<cmd>Telescope git_status<cr>", desc = "Git status" },
  { "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in buffer" },
  { "<leader>sS", "<cmd>Telescope git_stash<cr>", desc = "Git stash" },
  { "<leader>se", "<cmd>Telescope frecency<cr>", desc = "Frecency" },
  { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
  -- { "<leader>sd", group = "+DAP" },
  -- { "<leader>sdc", "<cmd>Telescope dap commands<cr>", desc = "Dap Commands" },
  -- { "<leader>sdb", "<cmd>Telescope dap list_breakpoints<cr>", desc = "Dap Breakpoints" },
  -- { "<leader>sdg", "<cmd>Telescope dap configurations<cr>", desc = "Dap Configurations" },
  -- { "<leader>sdv", "<cmd>Telescope dap variables<cr>", desc = "Dap Variables" },
  -- { "<leader>sdf", "<cmd>Telescope dap frames<cr>", desc = "Dap Frames" },
  {
    "<leader>sN",
    function()
      require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
    end,
    desc = "Search Neovim Config",
  },

  { "<leader>T", group = "+Todo" },
  { "<leader>Tt", "<cmd>TodoTelescope<cr>", desc = "Todo" },
  { "<leader>TT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
  { "<leader>Tx", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
  { "<leader>TX", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr><cr>", desc = "Todo/Fix/Fixme (Trouble)" },

  { "<leader>d", group = "+Debug" },
  -- { "<leader>db", require("dap").toggle_breakpoint, desc = "Breakpoint" },
  -- { "<leader>dc", require("dap").continue, desc = "Continue" },
  -- { "<leader>di", require("dap").step_into, desc = "Into" },
  -- { "<leader>do", require("dap").step_over, desc = "Over" },
  -- { "<leader>dO", require("dap").step_out, desc = "Out" },
  -- { "<leader>dr", require("dap").repl.toggle, desc = "Repl" },
  -- { "<leader>dl", require("dap").run_last, desc = "Last" },
  -- { "<leader>du", require("dapui").toggle, desc = "UI" },
  -- { "<leader>dx", require("dap").terminate, desc = "Exit" },

  { "<leader>n", group = "+Neogen" },
  { "<leader>ng", "<cmd>lua require('neogen').generate()<cr>", desc = "Generate Annotatin" },
  { "<leader>nf", "<cmd>lua require('neogen').generate({ type = 'func' })<cr>", desc = "Generate Function Annotation" },
  { "<leader>nt", "<cmd>lua require('neogen').generate({ type = 'type' })<cr>", desc = "Generate Type Annotation" },

  { "<leader>t", group = "+Tests" },
  { "<leader>p", group = "Package Manager" },
}