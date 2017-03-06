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
Plugin 'tomasr/molokai'
Plugin 'pangloss/vim-javascript'
Plugin 'kchmck/vim-coffee-script'
Plugin 'mattn/emmet-vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'wting/rust.vim'
Plugin 'cespare/vim-toml'
Plugin 'fatih/vim-go'
Plugin 'leafgarland/typescript-vim'
Plugin 'elixir-lang/vim-elixir'
Plugin 'JuliaLang/julia-vim'
Plugin 'ryanmjacobs/vim-arduino'
Plugin 'derekwyatt/vim-scala'
Plugin 'guns/vim-clojure-highlight'
Plugin 'kien/rainbow_parentheses.vim'
call vundle#end()

if $TERM == 'xterm-256color'
    set t_Co=256
endif

if has("gui_running")
    set guioptions-=T " Don't display the toolbar
    if has("gui_gtk2")
       "set guifont=Inconsolata\ 10
        set guifont=Monospace\ 9
    elseif has("gui_macvim")
        set guifont=Menlo\ Regular:h14
    elseif has("gui_win32")
        set guifont=Consolas:h11:cANSI
    endif
endif

" Colorscheme
let g:solarized_termcolors=256
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

" Ban the use of arrow keys!
"noremap <Up> <NOP>
"noremap <Down> <NOP>
"noremap <Left> <NOP>
"noremap <Right> <NOP>

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

" vim-go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" disable neovim defaults
set laststatus=1
set nohlsearch
set mouse=

" nginx conf
" https://arian.io/vim-syntax-highlighting-for-nginx/
au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/*,nginx.conf if &ft == '' | setfiletype nginx | endif

" markdown textwidth=80
au BufRead,BufNewFile *.md setlocal textwidth=80

"au VimEnter * RainbowParenthesesToggle
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces
