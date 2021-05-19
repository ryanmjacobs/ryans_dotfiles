" Required for Vundle
filetype off
set nocompatible
set runtimepath+=~/.vim/bundle/Vundle.vim

" Plugins
call vundle#begin()
Plugin 'zah/nim.vim'
Plugin 'isobit/vim-caddyfile'
Plugin 'evanleck/vim-svelte'
Plugin 'smerrill/vcl-vim-plugin'
Plugin 'StanAngeloff/php.vim'
Plugin 'ziglang/zig.vim'
Plugin 'harenome/vim-mipssyntax'
Plugin 'tomasr/molokai'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'sirtaj/vim-openscad'
"Plugin 'pangloss/vim-javascript'
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
Plugin 'posva/vim-vue'
Plugin 'tomlion/vim-solidity'
Plugin 'joukevandermaas/vim-ember-hbs'
Plugin 'digitaltoad/vim-pug'
Plugin 'hashivim/vim-terraform'
Plugin 'b4b4r07/vim-hcl'
Plugin 'scrooloose/nerdcommenter'
Plugin 'rhysd/vim-crystal'
Plugin 'mxw/vim-jsx'
"Plugin 'guns/vim-sexp'
Plugin 'vim-perl/vim-perl6'
Plugin 'wlangstroth/vim-racket'
Plugin 'Matt-Deacalion/vim-systemd-syntax'
Plugin 'BeneCollyridam/futhark-vim'
Plugin 'ElmCast/elm-vim'
Plugin 'lifepillar/pgsql.vim'
Plugin 'chr4/nginx.vim'
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

" Ban the use of arrow keys!
"noremap <Up> <NOP>
"noremap <Down> <NOP>
"noremap <Left> <NOP>
"noremap <Right> <NOP>

" Map F1 Key to escape
inoremap <F1> <Esc>
noremap  <F1> <Esc>

" Shortcut for dumping yy register
nnoremap L "0p

" File specific settings
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufRead *.git/COMMIT_EDITMSG set colorcolumn=72

" Emmet: trigger=<tab>
let g:user_emmet_expandabbr_key="<Tab>"
let g:user_emmet_install_global=0
autocmd FileType html,php,css,scss,vue EmmetInstall

" vim-go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" disable neovim defaults
set laststatus=1
set nohlsearch

" disable scrolling via mousa
set mouse=a
map <ScrollWheelUp> <nop>
map <ScrollWheelDown> <nop>

" syntax highlight .sql files as PostgreSQL
let g:sql_type_default = 'pgsql'

" nginx conf
" https://arian.io/vim-syntax-highlighting-for-nginx/
au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/*,nginx.conf if &ft == '' | setfiletype nginx | endif

" markdown textwidth=80
au BufRead,BufNewFile *.md setlocal textwidth=80

" .marko files are html (mainly)
au BufRead,BufNewFile *.marko setlocal syntax=html

"au VimEnter * RainbowParenthesesToggle
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces
map <Tab> <C-W>
map <Tab><Tab> <C-W>w

" nerdcommenter
map S  <Leader>c<Space>
map cc <Leader>c<Space>
let g:NERDAltDelims_c = 1
let g:NERDAltDelims_js = 1
let g:NERDAltDelims_javascript = 1
"let g:NERDDefaultAlign = 'right'

" require JSX pragma for syntax highlighting
" don't want to affect javascript syntax highlighting
let g:jsx_pragma_required = 1

" set <space> to leader key (mainly for vim-sexp)
nnoremap <Space> <Nop>
let maplocalleader=" "

" custom language tabstops
autocmd FileType yaml       setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType toml       setlocal shiftwidth=2 softtabstop=2 expandtab
"autocmd FileType ruby       setlocal shiftwidth=4 softtabstop=4 expandtab
autocmd FileType ruby       setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType typescript setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType html       setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType sql        setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType svelte     setlocal shiftwidth=2 softtabstop=2 expandtab
au BufRead,BufNewFile *.md  setlocal textwidth=80 formatoptions+=t

" blog
"command HR 'r ! c hr.c'
"cnoreabbrev hr HR
nnoremap <C-b> :center 80<cr>hhv0r#A<space><esc>40A#<esc>d80<bar>YppVr#kk.

set tabpagemax=1000
set noswapfile
set mouse=
