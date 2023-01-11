syntax on
colorscheme desert

set expandtab
set tabstop=4
set shiftwidth=4

filetype plugin indent on
execute pathogen#infect()
" Git blame plugin: https://github.com/zivyangll/git-blame.vim
nnoremap <Leader>b :<C-u>call gitblame#echo()<CR>
