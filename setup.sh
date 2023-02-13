#! /bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function link_config {
    # Link in config file to ~ dir if it doesn't already exist
    filename=$(basename "$1")
    if [[ -f ~/"$filename" ]]; then
        echo "$filename already found in home dir, refusing to replace"
    else
        echo "Symlinking $filename into home dir"
        ln -s "$1" ~
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
configs=($(find "${SCRIPT_DIR}"/home -maxdepth 1 -type f ))
for f in "${configs[@]}"; do
    link_config "$f"
done

# Disable nouveau video driver module
if [[ ! -f /etc/modprobe.d/disable-nouveau.conf ]]; then
    read -p "Disable nouveau module? (y/n)" confirm
    if [[ "$confirm" =~ ^[yY]+ ]]; then
        sudo ln -s "${SCRIPT_DIR}"/etc/modprobe.d/disable-nouveau.conf /etc/modprobe.d
        sudo update-initramfs -u
    fi
fi

if [[ ! -f "$HOME/.config/terminator/config" ]]; then
    mkdir -p $HOME/.config/terminator
    sudo ln -s "${SCRIPT_DIR}"/terminator/config $HOME/.config/terminator

fi

# Install some software
snapps=(code slack spotify vlc)
for snapp in "${snapps[@]}"; do
    if [[ -z $(snap list | grep "^$snapp\s") ]]; then
        sudo snap install "$snapp"
    fi
done

debs=(terminator ack vim)
for deb in "${debs[@]}"; do
    if ! dpkg-query --show --showformat='${db:Status-Status}\n' "$deb" | grep -q "^!(not-)installed"; then
        sudo apt install "$deb"
    fi
done

