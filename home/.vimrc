" Added for Vundle setup: https://github.com/VundleVim/Vundle.vim#about
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

syntax on
colorscheme desert

set expandtab
set tabstop=2
set shiftwidth=2

set wildmenu
set wildmode=list:longest

execute pathogen#infect()
" Git blame plugin: https://github.com/zivyangll/git-blame.vim
nnoremap <Leader>b :<C-u>call gitblame#echo()<CR>
nnoremap <Leader>p "0p
" Remap \p to paste just yank buffer (not delete buffer)
nnoremap <leader>p \"0p
