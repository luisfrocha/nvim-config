" Options
set nocompatible
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
let g:CommandTPreferredImplementation='lua'
set incsearch
set ignorecase
set smartcase
set showmode
set smarttab
set showcmd
set autoindent
set showmatch
set hlsearch
set history=1000
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set background=dark
set clipboard=unnamedplus
set completeopt=noinsert,menuone,noselect
set cursorline
set cursorcolumn
set hidden
set inccommand=split
set mouse=a
set number
set nobackup
set scrolloff=10

set splitbelow splitright
set title
set ttimeoutlen=0
set wildmenu

" Tabs size
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2

set t_Co=256

" True color if available
let term_program=$TERM_PROGRAM

" Check for conflicts with Apple Terminal app
if term_program !=? 'Apple_Terminal'
  set termguicolors
else
  "Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
  "If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color
  "support (see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
  if (empty($TMUX))
    if (has("nvim"))
      "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
      let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
    "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
    "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
    " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
    if (has("termguicolors"))
      set termguicolors
    endif
    if $TERM !=? 'xterm-256color'
      set termguicolors
    endif
  endif
endif

syntax on

" Italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

autocmd BufReadPost,BufNewFile *.vue setlocal filetype=vue

call plug#begin()
  " Appearance
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  " Plug 'navarasu/onedark.nvim'
  Plug 'rebelot/kanagawa.nvim'
  " Plug 'crusoexia/vim-monokai'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'eandrju/cellular-automaton.nvim'
  Plug 'mxw/vim-jsx'
  Plug 'pangloss/vim-javascript'
  Plug 'rafi/awesome-vim-colorschemes'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'romgrk/barbar.nvim'
  Plug 'kevinhwang91/promise-async'
  Plug 'APZelos/blamer.nvim'
  Plug 'kevinhwang91/nvim-hlslens'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'HampusHauffman/bionic.nvim'

  " Utilities
  Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
  Plug 'sheerun/vim-polyglot'
  Plug 'jiangmiao/auto-pairs'
  Plug 'ap/vim-css-color'
  Plug 'preservim/nerdtree'
  Plug 'godlygeek/tabular'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'mileszs/ack.vim'
  Plug 'tpope/vim-surround' " Surrounding ysw)
  Plug 'tc50cal/vim-terminal' " Vim Terminal
  Plug 'preservim/tagbar' " Tagbar for code navigation
  Plug 'mg979/vim-visual-multi', {'branch': 'master'} " Enable multi-cursors
  Plug 'echasnovski/mini.nvim'
  Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
  Plug 'jose-elias-alvarez/null-ls.nvim'

  " Completion / linters / formatters
  Plug 'neoclide/coc.nvim',  {'branch': 'release', 'do': 'yarn install --frozen-lockfile'}
  Plug 'plasticboy/vim-markdown'
  Plug 'yaegassy/coc-volar', {'do': 'yarn install --frozen-lockfile'}
  Plug 'yaegassy/coc-volar-tools', {'do': 'yarn install --frozen-lockfile'}
  Plug 'yaegassy/coc-intelephense'
  Plug 'iamcco/coc-tailwindcss',  {'do': 'yarn install --frozen-lockfile && yarn run build'}
  Plug 'neoclide/coc-eslint'
  Plug 'posva/vim-vue'
  Plug 'w0rp/ale'
  Plug 'Galooshi/vim-import-js'
  Plug 'mattn/emmet-vim'
  Plug 'AndrewRadev/tagalong.vim'
  Plug 'leafOfTree/vim-vue-plugin'
  Plug 'preservim/nerdcommenter'
  Plug 'tpope/vim-commentary' " For Commenting gcc & gc
  Plug 'terryma/vim-multiple-cursors'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'folke/which-key.nvim'

  " Git
  Plug 'airblade/vim-gitgutter'
  Plug 'elvessousa/sobrio'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'lambdalisue/nerdfont.vim'
  Plug 'ryanoasis/vim-devicons'
  Plug 'Xuyuanp/scrollbar.nvim'

  " nvim-cmp
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'

  " For vsnip users.
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'
call plug#end()

let g:blamer_enabled = 1
let g:blamer_delay = 300
let g:blamer_relative_time = 1
let g:blamer_date_format = '%m/%d/%Y %I:%M:%S 5p'

let g:vim_vue_plugin_config = {
      \'syntax': {
      \   'template': ['html'],
      \   'script': ['javascript'],
      \   'style': ['css'],
      \},
      \'full_syntax': [],
      \'initial_indent': [],
      \'attribute': 0,
      \'keyword': 0,
      \'foldexpr': 0,
      \'debug': 0,
      \}

" step 2: font configuration
" These are the basic settings to get the font to work (required):
" required if using https://github.com/bling/vim-airline
set guifont=Victor\ Mono\ Font:h16 " ,Hack\\ Nerd\\ Font\\ Mono\\ Font:h18
set encoding=UTF-8
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusShowIgnored = 1

let g:airline_theme='molokai'
let g:airline#extensions#tabline#enable = 1
let NERDTreeShowHidden=1
"  let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1
set runtimepath^=~/.config/nvim/bundle/ctrlp.vim

" Disable math tex conceal feature
let g:tex_conceal = ''
let g:vim_markdown_math = 1

" Markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_fenced_languages = ['tsx=typescriptreact']

" One Dark
" let g:onedark_terminal_italics = 1
" let g:onedark_config = {
"   \ 'style': 'darker',
"   \ 'transparent': v:true,
"   \ 'toggle_style_key': '<C-1>ts',
"   \ 'code_style': { 'keywords': 'bold' }
" \ }
" colorscheme onedark

" Monokai
" let g:monokai_term_italic = 1
" let g:monokai_gui_italic = 1
" colorscheme monokai

" Kanagawa
colorscheme kanagawa-wave

hi Normal guibg=NONE ctermbg=NONE

" Normal mode remappings
"  nnoremap <C-q> :q!<CR>
"  nnoremap <C-w> :q<CR>
nnoremap <S-F4> :bd<CR>
nnoremap <C-`> :5sp<CR>:terminal<CR>
nnoremap <C-s> :w<cr>

" Tabs
nnoremap <S-Tab> gT
nnoremap <Tab> gt
nnoremap <silent> <S-t> :tabnew<CR>

" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
noremap <c-S-up> <c-w>+
noremap <c-S-down> <c-w>-
noremap <c-S-left> <c-w>>
noremap <c-S-right> <c-w><
noremap <C-left> <C-w>h
noremap <C-right> <C-w>l

noremap <C-S-F> :Ag<cr>
let g:ackprg = 'ag --vimgrep'
set rtp+=/opt/homebrew/bin/fzf

noremap <C-S-O> :CtrlPMixed<cr>

" If GUI version of Vim is running set these options.
if has('gui_running')

    " Set the background tone.
    set background=dark

    " Set the color scheme.
    "  colorscheme molokai

    " Set a custom font you have installed on your computer.
    " Syntax: <font_name>\ <weight>\ <size>
    set guifont=Monospace\ Regular\ 12

    " Display more of the file by default.
    " Hide the toolbar.
    set guioptions-=T

    " Hide the the left-side scroll bar.
    set guioptions-=L

    " Hide the the left-side scroll bar.
    set guioptions-=r

    " Hide the the menu bar.
    set guioptions-=m

    " Hide the the bottom scroll bar.
    set guioptions-=b

    " Map the F4 key to toggle the menu, toolbar, and scroll bar.
    " <Bar> is the pipe character.
    " <CR> is the enter key.
    nnoremap <F4> :if &guioptions=~#'mTr'<Bar>
        \set guioptions-=mTr<Bar>
        \else<Bar>
        \set guioptions+=mTr<Bar>
        \endif<CR>

endif

" If Vim version is equal to or greater than 7.3 enable undofile.
" This allows you to undo changes to a file even after saving it.
if version >= 703
    set undodir=~/.config/nvim/backup
    set undofile
    set undoreload=100000
endif

nnoremap <C-d> Yp
nnoremap <C-BS> "_dd
"nnoremap <C-/> mzI/* <esc>A */<esc>`z
nnoremap <c-s-/> {count}<leader>ci
" Auto Commands
augroup auto_commands
  " Start NERDTree and put the cursor back in the other window, even if a file was specified.
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | endif | wincmd p
  autocmd FileType scss setlocal iskeyword+=@-@
  " autocmd BufReadPost,BufNewFile *.vue :CocCommand volar.action.splitEditors
  " Exit Vim if NERDTree is the only window remaining in the only tab.
  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
  autocmd BufEnter * if &modifiable && expand('%:p') != '' | NERDTreeFind | wincmd p | endif
  " If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
  autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
   \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
  autocmd BufEnter * BionicOn
augroup END

nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-l> :call CocActionAsync('jumpDefinition')<CR>

nmap <F8> :TagbarToggle<CR>

:set completeopt-=preview " For No Previews

let mapleader = '`'
:iabbrev </ </<C-X><C-O>
let g:ale_linters = { 'javascript': ['eslint']}
let g:ale_fixers = { 'javascript': ['prettier','eslint']}
let g:ale_fix_on_save = 1
nmap <leader>d <Plug>(ale_fix)

" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"

nmap <leader>o :Telescope find_files hidden=true no_ignore=true<CR>
nmap <C-S-j> :move+1<CR>
nmap <C-S-k> :move-2<CR>
let g:ale_sign_column_always = 1
" let g:minimap_width = 2
" let g:minimap_auto_start = 1
" let g:minimap_auto_start_win_enter = 1
" hi MinimapCurrentLine ctermfg=Green guifg=#50FA7B guibg=#32302f
" let g:minimap_cursor_color = 'MinimapCurrentLine'

lua <<EOF
  vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
  require('mini.map').setup()
  require('mini.pairs').setup()
  require('mini.indentscope').setup()
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

      -- Animate only if there are at least 3 windows
      subresize = animate.gen_subscroll.equal({ predicate = is_many_wins }),
    },
    open = {
      -- Animate for 400 milliseconds with linear easing
      timing = animate.gen_timing.linear({ duration = 50, unit = 'total' }),

      -- Animate with wiping from nearest edge instead of default static one
      winconfig = animate.gen_winconfig.wipe({ direction = 'from_edge' }),

      -- Make bigger windows more transparent
      winblend = animate.gen_winblend.linear({ from = 80, to = 100 }),
    },

    close = {
      -- Animate for 400 milliseconds with linear easing
      timing = animate.gen_timing.linear({ duration = 50, unit = 'total' }),

      -- Animate with wiping to nearest edge instead of default static one
      winconfig = animate.gen_winconfig.wipe({ direction = 'to_edge' }),

      -- Make bigger windows more transparent
      winblend = animate.gen_winblend.linear({ from = 100, to = 80 }),
    },
  })
  require('hlslens').setup()

  local kopts = {noremap = true, silent = true}

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

  require 'nvim-treesitter.configs'.setup {
      ensure_installed = {
        'css',
        'dockerfile',
        'graphql',
        'html',
        'javascript',
        'json',
        'json5',
        'lua',
        'php',
        'scss',
        'sql',
        'tsx',
        'typescript',
        'vim',
        'vue',
        'yaml'
      },
      highlight = {
          enable = true
      },
      incremental_selection = {
          enable = true,
          keymaps = {
              init_selection = "gnn",
              node_incremental = "gj",
              node_decremental = "gk",
              scope_incremental = "gs",
          },
      },
      textobjects = {
          enable = true
      },
      indent = {
          enable = true
      },
  }
  require("mason").setup()

  -- Set up nvim-cmp.
  local cmp = require'cmp'

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
                  same_file = 1, -- add to existing import statement
                  local_files = 2, -- git files or files with relative path markers
                  buffer_content = 3, -- loaded buffer content
                  buffers = 4, -- loaded buffer names
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
              inlay_hints_format = { -- format options for individual hint kind
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
      end,
  })
  local null_ls = require("null-ls")
  null_ls.setup({
      sources = {
          null_ls.builtins.diagnostics.eslint, -- eslint or eslint_d
          null_ls.builtins.code_actions.eslint, -- eslint or eslint_d
          null_ls.builtins.formatting.prettier -- prettier, eslint, eslint_d, or prettierd
      },
  })
EOF
