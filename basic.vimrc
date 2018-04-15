" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

" If you prefer the old-style vim functionalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim80/vimrc_example.vim or the vim manual
" and configure vim to your own liking!

" do not load defaults if ~/.vimrc is missing
"let skip_defaults_vim=1
"
if $TERM == 'xterm-256color'
    set t_Co=256
endif

" Colorscheme
silent! colorscheme molokai
set background=dark

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

" emmet tab trigger
"let g:user_emmet_expandabbr_key = '<Tab>'
"imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
