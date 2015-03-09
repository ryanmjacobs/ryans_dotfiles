""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc
"
" Author:  Ryan Jacobs <ryan.mjacobs@gmail.com>
" Updated: March 08, 2015
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 

" Required for Vundle
set nocompatible
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim

" Plugins
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'tomasr/molokai'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'kchmck/vim-coffee-script'
Plugin 'mattn/emmet-vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'wting/rust.vim'
Plugin 'cespare/vim-toml'
call vundle#end()

if $TERM == 'xterm-256color'
    set t_Co=256
endif

if has("gui_running")
    set guioptions-=T " Don't display the toolbar
    if has("gui_gtk2")
        set guifont=Inconsolata\ 10
    elseif has("gui_macvim")
        set guifont=Menlo\ Regular:h14
    elseif has("gui_win32")
        set guifont=Consolas:h11:cANSI
    endif
endif

" Colorscheme
let g:solarized_termcolors=256
silent colorscheme molokai
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

" Ban the use of arrow keys!
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Map F1 Key to escape
inoremap <F1> <Esc>
noremap  <F1> <Esc>

" File specific settings
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufRead *.git/COMMIT_EDITMSG set colorcolumn=72

" Emmet: trigger=<tab>
let g:user_emmet_expandabbr_key="<Tab>"
let g:user_emmet_install_global=0
autocmd FileType html,php,css,scss EmmetInstall
