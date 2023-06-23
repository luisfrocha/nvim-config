vim.cmd('source ~/.config/nvim/script.vim')
-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not vim.loop.fs_stat(lazypath) then
--   vim.fn.system({
--     "git",
--     "clone",
--     "--filter=blob:none",
--     "https://github.com/folke/lazy.nvim.git",
--     "--branch=stable", -- latest stable release
--     lazypath,
--   })
-- end
-- vim.opt.rtp:prepend(lazypath)
-- require("lazy").setup({}, {})
require('mason').setup()

vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
if pcall(function()
      require('mini.map').setup()
    end) == false then
  error("Could not load mini.map", 2)
end
require('mini.pairs').setup()
require('mini.indentscope').setup()
require('mini.fuzzy').setup()
require('mini.completion').setup()
-- require('mini.comment').setup({
--     ignore_blank_line = true
--   })
local animate = require('mini.animate')
animate.setup({
  cursor = {
    -- Animate for 200 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 150, unit = 'total' }),

    -- Animate with shortest line for any cursor move
    path = animate.gen_path.line({
      predicate = function() return true end,
    }),
  },
  scroll = {
    enable = false,
  },
  resize = {
    -- Animate for 200 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 50, unit = 'total' }),
  },
  open = {
    -- Animate for 400 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 50, unit = 'total' }),

    -- Animate with wiping from nearest edge instead of default static one
    winconfig = animate.gen_winconfig.wipe({ direction = 'from_edge' }),

    -- Make bigger windows more transparent
    winblend = animate.gen_winblend.linear({ from = 80, to = 100 }),
  },

})
require('hlslens').setup()

local kopts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', 'n',
  [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
  kopts)
vim.api.nvim_set_keymap('n', 'N',
  [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
  kopts)
vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)

-- Set up nvim-cmp.
local cmp = require 'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Set up lspconfig.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--   capabilities = capabilities
-- }

local lspconfig = require("lspconfig")
-- require("mason-lspconfig").setup()

lspconfig.tsserver.setup({
  -- Needed for inlayHints. Merge this table with your settings or copy
  -- it from the source if you want to add your own init_options.
  init_options = require("nvim-lsp-ts-utils").init_options,
  --
  on_attach = function(client, bufnr)
    local ts_utils = require("nvim-lsp-ts-utils")

    -- defaults
    ts_utils.setup({
      debug = false,
      disable_commands = false,
      enable_import_on_completion = false,

      -- import all
      import_all_timeout = 5000, -- ms
      -- lower numbers = higher priority
      import_all_priorities = {
        same_file = 1,      -- add to existing import statement
        local_files = 2,    -- git files or files with relative path markers
        buffer_content = 3, -- loaded buffer content
        buffers = 4,        -- loaded buffer names
      },
      import_all_scan_buffers = 100,
      import_all_select_source = false,
      -- if false will avoid organizing imports
      always_organize_imports = true,

      -- filter diagnostics
      filter_out_diagnostics_by_severity = {},
      filter_out_diagnostics_by_code = {},

      -- inlay hints
      auto_inlay_hints = true,
      inlay_hints_highlight = "Comment",
      inlay_hints_priority = 200, -- priority of the hint extmarks
      inlay_hints_throttle = 150, -- throttle the inlay hint request
      inlay_hints_format = {      -- format options for individual hint kind
        Type = {},
        Parameter = {},
        Enum = {},
        -- Example format customization for `Type` kind:
        -- Type = {
        --     highlight = "Comment",
        --     text = function(text)
        --         return "->" .. text:sub(2)
        --     end,
        -- },
      },

      -- update imports on file move
      update_imports_on_move = false,
      require_confirmation_on_move = false,
      watch_dir = nil,
    })

    -- required to fix code action ranges and filter diagnostics
    ts_utils.setup_client(client)

    -- no default maps, so you may want to define some here
    local opts = { silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)

    if client.resolved_capabilities.document_highlight then
      vim.cmd [[
          hi! LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
          hi! LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
          hi! LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
        ]]
      vim.api.nvim_create_augroup('lsp_document_highlight', {
        clear = false
      })
      vim.api.nvim_clear_autocmds({
        buffer = bufnr,
        group = 'lsp_document_highlight',
      })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = 'lsp_document_highlight',
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = 'lsp_document_highlight',
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
require("lspsaga").setup({})
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint,  -- eslint or eslint_d
    null_ls.builtins.code_actions.eslint, -- eslint or eslint_d
    null_ls.builtins.formatting.prettier  -- prettier, eslint, eslint_d, or prettierd
  },
})
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

require 'window-picker'.setup({
  autoselect_one = true,
  include_current = false,
  filter_rules = {
    -- filter using buffer options
    bo = {
      -- if the file type is one of following, the window will be ignored
      filetype = { 'neo-tree', "neo-tree-popup", "notify" },

      -- if the buffer type is one of following, the window will be ignored
      buftype = { 'terminal', "quickfix" },
    },
  },
  other_win_hl_color = '#e35e4f',
})

-- neo-tree config
-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- If you want icons for diagnostic errors, you'll need to define them somewhere:
vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
-- NOTE: this is changed from v1.x, which used the old style of highlight groups
-- in the form "LspDiagnosticsSignWarning"

require("neo-tree").setup({
  auto_clean_after_session_restore = true, -- Automatically clean up broken neo-tree buffers saved in sessions
  close_floats_on_escape_key = true,
  enable_modified_markers = true,          -- Show markers for files with unsaved changes.
  enable_opened_markers = true,            -- Enable tracking of opened files. Required for `components.name.highlight_opened_files`
  enable_refresh_on_write = true,          -- Refresh the tree when a file is written. Only used if `use_libuv_file_watcher` is false.
  git_status_async = true,
  -- These options are for people with VERY large git repos
  git_status_async_options = {
    batch_size = 1000, -- how many lines of git status results to process at a time
    batch_delay = 10,  -- delay in ms between batches. Spreads out the workload to let other processes run.
    max_lines = 10000, -- How many lines of git status results to process. Anything after this will be dropped.
    -- Anything before this will be used. The last items to be processed are the untracked files.
  },
  open_files_do_not_replace_types = { "terminal", "trouble", "qf", "terminal" }, -- when opening files, do not use windows containing these filetypes or buftypes
  popup_border_style = "rounded",
  sort_case_insensitive = true,                                                  -- used when sorting files and directories in the tree
  reveal_force_cwd = true,
  enable_diagnostics = true,
  sort_function = nil, -- use a custom function for sorting files and directories in the tree
  source_selector = {
    winbar = true,     -- toggle to show selector on winbar
  },
  default_component_configs = {
    container = {
      enable_character_fade = true,
    },
    name = {
      highlight_opened_files = true,
    },
  },
  window = {
    position = "float",
    popup = {
      size = {
        height = "90%",
        width = "90%",
      }
    },
    mappings = {
      ["a"] = {
        "add",
        config = {
          show_path = "relative",
        }
      },
      ["e"] = "toggle_auto_expand_width",
      ["R"] = "refresh",
    }
  },
  nesting_rules = {},
  filesystem = {
    scan_mode = "deep",
    filtered_items = {
      visible = true,                       -- when true, they will just be displayed differently than normal items
      force_visible_in_empty_folder = true, -- when true, hidden files will be shown if the root folder is otherwise empty
      hide_dotfiles = false,
      hide_hidden = false,                  -- only works on Windows for hidden files/directories
      hide_by_name = {
        "node_modules",
      },
      never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
        ".DS_Store",
        "thumbs.db",
        ".git",
      },
    },
    follow_current_file = true, -- This will find and focus the file in the active buffer every
    -- time the current file is changed while the tree is open.
    -- hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
    -- in whatever position is specified in window.position
    -- "open_current", -- netrw disabled, opening a directory opens within the
    -- window like netrw would, regardless of window.position
    -- "disabled", -- netrw left alone, neo-tree does not handle opening dirs
    use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
    -- instead of relying on nvim autocmd events.
  },
  buffers = {
    show_unloaded = true,
  },
  git_status = {
    window = {
      position = "float",
    }
  },
})

vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
vim.keymap.set("n", "<F12>", function()
  vim.cmd([[Lspsaga peek_definition]])
end)
-- Save buffer
vim.keymap.set('n', '<C-s>', function()
  vim.cmd([[:w]])
end)
-- Save all buffers
vim.keymap.set('n', '<C-S-s>', function()
  vim.cmd([[:wa]])
end)
-- Close buffer
vim.keymap.set("n", "<C-S-w>", function()
  vim.cmd([[BufferClose]])
end)
-- BarBar: go to previous buffer tab
vim.keymap.set("n", "<C-,>", function()
  vim.cmd([[BufferPrevious]])
end)
-- BarBar: go to next buffer tab
vim.keymap.set("n", "<C-.>", function()
  vim.cmd([[BufferNext]])
end)
-- Show floating terminal window
vim.keymap.set("n", "<C-`>", function()
  vim.cmd([[FloatermToggle]])
end)
-- Undo last action
vim.keymap.set("n", "<C-u>", function()
  vim.cmd([[:u]])
end)

-- local possession = require("nvim-possession")
-- vim.keymap.set("n", "<leader>sl", function()
--     possession.list()
-- end)
-- vim.keymap.set("n", "<leader>sn", function()
--     possession.new()
-- end)
-- vim.keymap.set("n", "<leader>su", function()
--     possession.update()
-- end)
-- vim.keymap.set("n", "<leader>sd", function()
--     possession.delete()
-- end)
-- possession.setup({
--   autoload = true,
--   autoswitch = {
--     enable = true,
--   },
--   post_hook = function()
--     require('neo-tree').focus()
--   end
-- })

local notify = require('notify')

local function get_buffer_count()
  local len = 0
  local vim_fn = vim.fn

  for buffer = 1, vim_fn.bufnr('$') do
    if string.gsub(vim_fn.buffer_name(buffer), '[ \t]+%f[\r\n%z]', '') ~= "" then
      len = len + 1
    end
  end

  return len
end

local function load_buffers()
  local count = get_buffer_count()
  if count == 0 then
    vim.cmd([[ Neotree ]])
  end
  notify("Welcome back", "info", { title = "System" })
end

require("auto-session").setup {
  log_level = "error",
  auto_session_suppress_dirs = { "~/", "~/Sites", "~/Downloads", "/" },
  auto_save_enabled = true,
  auto_restore_enabled = true,
  post_restore_cmds = { load_buffers },
}

require('barbar').setup({
  -- auto_hide = true
})

require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      "node%_modules/.*",
    },
  }
}

vim.api.nvim_create_autocmd("CursorHold", {
  buffer = bufnr,
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end
})

require('nvim-treesitter').setup()

require('nvim-ts-autotag').setup()
require('trouble').setup({
  auto_open = true,
  use_diagnostic_signs = true,
  height = 5,
})
vim.keymap.set("n", "<leader>xx", [[LspTroubleToggle]])
-- triggers CursorHold event faster
vim.opt.updatetime = 200

require("barbecue").setup({
  create_autocmd = false, -- prevent barbecue from updating itself automatically
})

vim.api.nvim_create_autocmd({
  "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
  "BufWinEnter",
  "CursorHold",
  "InsertLeave",

  -- include this if you have set `show_modified` to `true`
  "BufModifiedSet",
}, {
  group = vim.api.nvim_create_augroup("barbecue.updater", {}),
  callback = function()
    require("barbecue.ui").update()
  end,
})
require('mini.fuzzy').setup()
require('mini.completion').setup()
require('mini.comment').setup()

local animate = require('mini.animate')
animate.setup({
  cursor = {
    -- Animate for 200 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 150, unit = 'total' }),

    -- Animate with shortest line for any cursor move
    path = animate.gen_path.line({
      predicate = function() return true end,
    }),
  },
  scroll = {
    enable = false,
  },
  resize = {
    -- Animate for 200 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 50, unit = 'total' }),
  },
  open = {
    -- Animate for 400 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 50, unit = 'total' }),

    -- Animate with wiping from nearest edge instead of default static one
    winconfig = animate.gen_winconfig.wipe({ direction = 'from_edge' }),

    -- Make bigger windows more transparent
    winblend = animate.gen_winblend.linear({ from = 80, to = 100 }),
  },

})
require('hlslens').setup()

local kopts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', 'n',
  [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
  kopts)
vim.api.nvim_set_keymap('n', 'N',
  [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
  kopts)
vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)

-- Set up nvim-cmp.
local cmp = require 'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Set up lspconfig.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--   capabilities = capabilities
-- }

local lspconfig = require("lspconfig")
require("mason-lspconfig").setup()

lspconfig.tsserver.setup({
  -- Needed for inlayHints. Merge this table with your settings or copy
  -- it from the source if you want to add your own init_options.
  init_options = require("nvim-lsp-ts-utils").init_options,
  --
  on_attach = function(client, bufnr)
    local ts_utils = require("nvim-lsp-ts-utils")

    -- defaults
    ts_utils.setup({
      debug = false,
      disable_commands = false,
      enable_import_on_completion = false,

      -- import all
      import_all_timeout = 5000, -- ms
      -- lower numbers = higher priority
      import_all_priorities = {
        same_file = 1,      -- add to existing import statement
        local_files = 2,    -- git files or files with relative path markers
        buffer_content = 3, -- loaded buffer content
        buffers = 4,        -- loaded buffer names
      },
      import_all_scan_buffers = 100,
      import_all_select_source = false,
      -- if false will avoid organizing imports
      always_organize_imports = true,

      -- filter diagnostics
      filter_out_diagnostics_by_severity = {},
      filter_out_diagnostics_by_code = {},

      -- inlay hints
      auto_inlay_hints = true,
      inlay_hints_highlight = "Comment",
      inlay_hints_priority = 200, -- priority of the hint extmarks
      inlay_hints_throttle = 150, -- throttle the inlay hint request
      inlay_hints_format = {      -- format options for individual hint kind
        Type = {},
        Parameter = {},
        Enum = {},
        -- Example format customization for `Type` kind:
        -- Type = {
        --     highlight = "Comment",
        --     text = function(text)
        --         return "->" .. text:sub(2)
        --     end,
        -- },
      },

      -- update imports on file move
      update_imports_on_move = false,
      require_confirmation_on_move = false,
      watch_dir = nil,
    })

    -- required to fix code action ranges and filter diagnostics
    ts_utils.setup_client(client)

    -- no default maps, so you may want to define some here
    local opts = { silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)

    if client.resolved_capabilities.document_highlight then
      vim.cmd [[
          hi! LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
          hi! LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
          hi! LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
        ]]
      vim.api.nvim_create_augroup('lsp_document_highlight', {
        clear = false
      })
      vim.api.nvim_clear_autocmds({
        buffer = bufnr,
        group = 'lsp_document_highlight',
      })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = 'lsp_document_highlight',
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = 'lsp_document_highlight',
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
require("lspsaga").setup({})
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint,  -- eslint or eslint_d
    null_ls.builtins.code_actions.eslint, -- eslint or eslint_d
    null_ls.builtins.formatting.prettier  -- prettier, eslint, eslint_d, or prettierd
  },
})
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

require 'window-picker'.setup({
  autoselect_one = true,
  include_current = false,
  filter_rules = {
    -- filter using buffer options
    bo = {
      -- if the file type is one of following, the window will be ignored
      filetype = { 'neo-tree', "neo-tree-popup", "notify" },

      -- if the buffer type is one of following, the window will be ignored
      buftype = { 'terminal', "quickfix" },
    },
  },
  other_win_hl_color = '#e35e4f',
})

-- neo-tree config
-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- If you want icons for diagnostic errors, you'll need to define them somewhere:
vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
-- NOTE: this is changed from v1.x, which used the old style of highlight groups
-- in the form "LspDiagnosticsSignWarning"

require("neo-tree").setup({
  auto_clean_after_session_restore = true, -- Automatically clean up broken neo-tree buffers saved in sessions
  close_floats_on_escape_key = true,
  enable_modified_markers = true,          -- Show markers for files with unsaved changes.
  enable_opened_markers = true,            -- Enable tracking of opened files. Required for `components.name.highlight_opened_files`
  enable_refresh_on_write = true,          -- Refresh the tree when a file is written. Only used if `use_libuv_file_watcher` is false.
  git_status_async = true,
  -- These options are for people with VERY large git repos
  git_status_async_options = {
    batch_size = 1000, -- how many lines of git status results to process at a time
    batch_delay = 10,  -- delay in ms between batches. Spreads out the workload to let other processes run.
    max_lines = 10000, -- How many lines of git status results to process. Anything after this will be dropped.
    -- Anything before this will be used. The last items to be processed are the untracked files.
  },
  open_files_do_not_replace_types = { "terminal", "trouble", "qf", "terminal" }, -- when opening files, do not use windows containing these filetypes or buftypes
  popup_border_style = "rounded",
  sort_case_insensitive = true,                                                  -- used when sorting files and directories in the tree
  reveal_force_cwd = true,
  enable_diagnostics = true,
  sort_function = nil, -- use a custom function for sorting files and directories in the tree
  source_selector = {
    winbar = true,     -- toggle to show selector on winbar
  },
  default_component_configs = {
    container = {
      enable_character_fade = true,
    },
    name = {
      highlight_opened_files = true,
    },
  },
  window = {
    position = "float",
    popup = {
      size = {
        height = "90%",
        width = "90%",
      }
    },
    mappings = {
      ["a"] = {
        "add",
        config = {
          show_path = "relative",
        }
      },
      ["e"] = "toggle_auto_expand_width",
      ["R"] = "refresh",
    }
  },
  nesting_rules = {},
  filesystem = {
    scan_mode = "deep",
    filtered_items = {
      visible = true,                       -- when true, they will just be displayed differently than normal items
      force_visible_in_empty_folder = true, -- when true, hidden files will be shown if the root folder is otherwise empty
      hide_dotfiles = false,
      hide_hidden = false,                  -- only works on Windows for hidden files/directories
      hide_by_name = {
        "node_modules",
      },
      never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
        ".DS_Store",
        "thumbs.db",
        ".git",
      },
    },
    follow_current_file = true, -- This will find and focus the file in the active buffer every
    -- time the current file is changed while the tree is open.
    -- hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
    -- in whatever position is specified in window.position
    -- "open_current", -- netrw disabled, opening a directory opens within the
    -- window like netrw would, regardless of window.position
    -- "disabled", -- netrw left alone, neo-tree does not handle opening dirs
    use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
    -- instead of relying on nvim autocmd events.
  },
  buffers = {
    show_unloaded = true,
  },
  git_status = {
    window = {
      position = "float",
    }
  },
})

vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
vim.keymap.set("n", "<F12>", function()
  vim.cmd([[Lspsaga peek_definition]])
end)
-- Close buffer
vim.keymap.set("n", "<C-S-w>", function()
  vim.cmd([[BufferClose]])
end)
-- BarBar cycling through tabs
vim.keymap.set("n", "<C-,>", function()
  vim.cmd([[BufferPrevious]])
end)
vim.keymap.set("n", "<C-.>", function()
  vim.cmd([[BufferNext]])
end)
vim.keymap.set("n", "<C-`>", function()
  vim.cmd([[FloatermToggle]])
end)
vim.keymap.set("n", "<C-u>", function()
  vim.cmd([[:u]])
end)

-- local possession = require("nvim-possession")
-- vim.keymap.set("n", "<leader>sl", function()
--     possession.list()
-- end)
-- vim.keymap.set("n", "<leader>sn", function()
--     possession.new()
-- end)
-- vim.keymap.set("n", "<leader>su", function()
--     possession.update()
-- end)
-- vim.keymap.set("n", "<leader>sd", function()
--     possession.delete()
-- end)
-- possession.setup({
--   autoload = true,
--   autoswitch = {
--     enable = true,
--   },
--   post_hook = function()
--     require('neo-tree').focus()
--   end
-- })

local notify = require('notify')

local function get_buffer_count()
  local len = 0
  local vim_fn = vim.fn

  for buffer = 1, vim_fn.bufnr('$') do
    if string.gsub(vim_fn.buffer_name(buffer), '[ \t]+%f[\r\n%z]', '') ~= "" then
      len = len + 1
    end
  end

  return len
end

local function load_buffers()
  local count = get_buffer_count()
  if count == 0 then
    vim.cmd([[ Neotree ]])
  end
  notify("Welcome back", "info", { title = "System" })
end

require("auto-session").setup {
  log_level = "error",
  auto_session_suppress_dirs = { "~/", "~/Sites", "~/Downloads", "/" },
  auto_save_enabled = true,
  auto_restore_enabled = true,
  post_restore_cmds = { load_buffers },
}

require('barbar').setup({
  -- auto_hide = true
})

require('nvim-treesitter').setup()

require('nvim-ts-autotag').setup()
require('trouble').setup({
  auto_open = true,
  use_diagnostic_signs = true,
})
vim.keymap.set("n", "<leader>xx", [[LspTroubleToggle]])
-- triggers CursorHold event faster
vim.opt.updatetime = 200

require("barbecue").setup({
  create_autocmd = false, -- prevent barbecue from updating itself automatically
})

vim.api.nvim_create_autocmd({
  "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
  "BufWinEnter",
  "CursorHold",
  "InsertLeave",

  -- include this if you have set `show_modified` to `true`
  "BufModifiedSet",
}, {
  group = vim.api.nvim_create_augroup("barbecue.updater", {}),
  callback = function()
    require("barbecue.ui").update()
  end,
})

vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
}

require("symbols-outline").setup({
  auto_preview = true
})

require('goto-preview').setup {}

require('spectre').setup()

require("todo-comments").setup()
