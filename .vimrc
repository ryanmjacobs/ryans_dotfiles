""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc
"
" Maintained By: Ryan Jacobs <ryan.mjacobs@gmail.com>
" March 18, 2014 -> File creation.
"  June 03, 2014 -> Moved .gvimrc into .vimrc.
"  June 17, 2014 -> Always map <F1> to <Esc>.
"  June 21, 2014 -> Add other style of indentation: tabs. I prefer spaces but
"                       if a project needs to be consistent... I'll adapt.
" Sept. 06, 2014 -> Always display line numbers with `set ruler`
" Sept. 08, 2014 -> Force Markdown syntax on *.md
" Sept. 11, 2014 -> Exception handling of color scheme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
" Enable Pathogen
execute pathogen#infect()

" Enable 256 colors if the terminal supports it
if $COLORTERM == 'gnome-terminal' || $TERM == 'xterm-256color'
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

" Highlight column 80
set colorcolumn=80

" Always display line numbers
set ruler

" Load color schemes if possible
try
    colorscheme molokai
catch
endtry

" Enable syntax highlighting and auto-indentation
syntax on
filetype plugin indent on

" Force Markdown syntax highlighting on *.md
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

"""""""""" Tab Settings """"""""""
" Pressing <Tab> = insert 4 spaces
function! IndentSpaces()
    set tabstop=4
    set shiftwidth=4
    set expandtab
endfunction

" Pressing <Tab> = insert a tab
" Display tabs as 4 columns wide
function! IndentTabs()
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set noexpandtab
endfunction

call IndentSpaces()
"""""""""" End Tab Settings """"""""""

" Ban the use of arrow keys (hjkl is more efficient anyways)
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Map F1 Key to escape
inoremap <F1> <Esc>
noremap  <F1> <Esc>

" Append modeline after last line in buffer with <Leader>ml
function! AppendModeline()
    let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
    let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
