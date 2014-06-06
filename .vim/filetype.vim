""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .vim/filetype.vim
"
" Loads extra filetypes into vim.
"
" Maintained By: Ryan Jacobs <ryan.mjacobs@gmail.com>
" June 05, 2014 -> Initial creation. Add Arduino .ino files.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists("did_load_filetypes")
    finish
endif

" Arduino: .ino files
augroup filetypedetect
    au! BufRead,BufNewFile *.ino  setfiletype arduino
augroup END 
