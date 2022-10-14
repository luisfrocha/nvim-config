" Options
set nocompatible " use vim defaults
set background=dark
set clipboard=unnamedplus
set completeopt=noinsert,menuone,noselect
set cursorline
set hidden
set inccommand=split
set mouse=a
set number
set relativenumber
set splitbelow splitright
set title
set ttimeoutlen=0
set wildmenu

" Tabs size
set expandtab
set shiftwidth=2
set tabstop=2

filetype plugin indent on
syntax on

set t_Co=256

" True color if available
let term_program=$TERM_PROGRAM

" Check for conflicts with Apple Terminal app
if term_program !=? 'Apple_Terminal'
  set termguicolors
else
  if $TERM !=? 'xterm-256color'
    set termguicolors
  endif
endif

" Italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

call plug#begin()
  " Appearance
  Plug 'vim-airline/vim-airline'
  " Plug 'ryanoasis/vim-devicons'

  " Utilities
  Plug 'sheerun/vim-polyglot'
  Plug 'jiangmiao/auto-pairs'
  Plug 'ap/vim-css-color'
  Plug 'preservim/nerdtree'
  Plug 'godlygeek/tabular'

  " Completion / linters / formatters
  Plug 'neoclide/coc.nvim',  {'branch': 'master', 'do': 'yarn install'}
  Plug 'plasticboy/vim-markdown'

  " Git
  Plug 'airblade/vim-gitgutter'
  Plug 'elvessousa/sobrio'
  Plug 'preservim/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'ryanoasis/vim-devicons'
call plug#end()

" step 2: font configuration
" These are the basic settings to get the font to work (required):
" required if using https://github.com/bling/vim-airline
set guifont=Victor\ Mono\ Font:h16
set encoding=UTF-8
let g:airline_powerline_fonts=1
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusShowIgnored = 1

let g:airline_theme='sobrio'
let g:airline#extensions#tabline#enable = 1
let NERDTreeShowHidden=1
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
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

" Normal mode remappings
nnoremap <C-q> :q!<CR>
nnoremap <C-w> :q<CR>
nnoremap <F4> :bd<CR>
nnoremap <F5> :NERDTreeToggle<CR>
nnoremap <C-`> :sp<CR>:terminal<CR>

" Tabs
nnoremap <S-Tab> gT
nnoremap <Tab> gt
nnoremap <silent> <S-t> :tabnew<CR>

" Auto Commands
augroup auto_commands
  autocmd VimEnter * NERDTree
  autocmd FileType scss setlocal iskeyword+=@-@
augroup END
