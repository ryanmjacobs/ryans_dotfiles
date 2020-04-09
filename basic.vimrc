runtime! archlinux.vim

if $TERM == 'xterm-256color'
    set t_Co=256
endif

" Colorscheme
set background=dark
silent! colorscheme molokai

" Syntax highlighting and auto-indentation
syntax enable
filetype plugin indent on

" Misc. Options
set ruler            " Always display line numbers
set colorcolumn=80   " Highlight column 80
set nrformats-=octal " Stop skipping 8s and 9s when incrementing with Ctrl-A

" Press <Tab> = insert 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" disable neovim defaults
set laststatus=1
set nohlsearch
set mouse=
