#! /bin/bash

function link_config {
    # Link in config file to ~ dir if it doesn't already exist
    [[ -f ~/"$1" ]] || ln -s $(pwd)/"$1" ~
}

# Install vim pathogen plugin handler: https://github.com/tpope/vim-pathogen
[[ -f ~/.vim/autoload/pathogen.vim ]] || \
    (mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim)

# Install git blame plugin: https://github.com/zivyangll/git-blame.vim
[[ -d ~/.vim/bundle/git-blame.vim ]] || (cd ~/.vim/bundle && \
    git clone git@github.com:zivyangll/git-blame.vim.git)

# Link top-level config files into $HOME
configs=($(find . -maxdepth 1 -type f ! -name README.md ! -name setup.sh))
for f in "${configs[@]}"; do
    link_config "$f"
done
[[ -f /etc/modprobe.d/disable-nouveau.conf ]] || \
    sudo ln -s $(pwd)/etc/modprobe.d/disable-nouveau.conf /etc/modprobe.d