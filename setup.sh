#! /bin/bash

function link_config {
    # Link in config file to ~ dir if it doesn't already exist
    if [[ -f ~/"$1" ]]; then
        echo "$1 already found in home dir, refusing to replace"
    else
        echo "Symlinking $1 into home dir"
        ln -s $(pwd)/"$1" ~
    fi
}

# Install vim pathogen plugin handler: https://github.com/tpope/vim-pathogen
if [[ ! -f ~/.vim/autoload/pathogen.vim ]]; then
    mkdir -p ~/.vim/autoload ~/.vim/bundle
    which curl > /dev/null || sudo apt install -y curl
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

# Install git blame plugin: https://github.com/zivyangll/git-blame.vim
if [[ ! -d ~/.vim/bundle/git-blame.vim ]]; then
    cd ~/.vim/bundle
    which git > /dev/null || sudo apt install -y git
    git clone git@github.com:zivyangll/git-blame.vim.git
fi

# Link top-level config files into $HOME
configs=($(find home -maxdepth 1 -type f ))
for f in "${configs[@]}"; do
    link_config "$f"
done

# Disable nouveau video driver module
if [[ ! -f /etc/modprobe.d/disable-nouveau.conf ]]; then
    read -p "Disable nouveau module? (y/n)" confirm
    if [[ "$confirm" =~ ^[yY]+ ]]; then
        sudo ln -s $(pwd)/etc/modprobe.d/disable-nouveau.conf /etc/modprobe.d
        sudo update-initramfs -u
    fi
fi