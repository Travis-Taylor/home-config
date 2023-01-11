#! /bin/bash

# Install vim pathogen plugin handler: https://github.com/tpope/vim-pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Install git blame plugin: https://github.com/zivyangll/git-blame.vim
cd ~/.vim/bundle && \
    git clone git@github.com:zivyangll/git-blame.vim.git

#TODO: fix syntax
#find . -maxdepth 1 -type f ! -name README.md | xargs -I{} ln -s $(pwd)/{} ~