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
set showcmd
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
set nowrap
set scrolloff=10

"  set relativenumber
set splitbelow splitright
set title
set ttimeoutlen=0
set wildmenu

" Tabs size
set expandtab
set shiftwidth=2
set tabstop=2

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
  Plug 'joshdick/onedark.vim'

  " Utilities
  Plug 'sheerun/vim-polyglot'
  Plug 'jiangmiao/auto-pairs'
  Plug 'ap/vim-css-color'
  Plug 'preservim/nerdtree'
  Plug 'godlygeek/tabular'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'mileszs/ack.vim'

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

  " Git
  Plug 'airblade/vim-gitgutter'
  Plug 'elvessousa/sobrio'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'lambdalisue/nerdfont.vim'
  Plug 'ryanoasis/vim-devicons'
call plug#end()

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
set guifont=Victor\ Mono\ Font:h16
set encoding=UTF-8
let g:airline_powerline_fonts=1
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusShowIgnored = 1

let g:airline_theme='onedark'
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
let g:onedark_terminal_italics = 1
colorscheme onedark
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

noremap <C-S-F> :Ag

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
nnoremap <C-/> mzI/* <esc>A */<esc>`z

" Auto Commands
augroup auto_commands
  " Start NERDTree and put the cursor back in the other window, even if a file was specified.
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | endif | wincmd p
  autocmd FileType scss setlocal iskeyword+=@-@
  autocmd BufReadPost,BufNewFile *.vue :CocCommand volar.action.splitEditors
  " Exit Vim if NERDTree is the only window remaining in the only tab.
  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
  " If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
  autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
augroup END

nnoremap <C-e> :NERDTreeToggle<CR>

let meapleader = '`'
:iabbrev </ </<C-X><C-O>
