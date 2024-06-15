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
# Install some software
snapps=(code slack spotify vlc)
for snapp in "${snapps[@]}"; do
    if [[ -z $(snap list | grep "^$snapp\s") ]]; then
        sudo snap install "$snapp"
    fi
done

debs=(curl git terminator ack vim git git-lfs inkscape)
for deb in "${debs[@]}"; do
    if ! dpkg-query --show --showformat='${db:Status-Status}\n' "$deb" | grep -q "^installed"; then
        sudo apt install -y "$deb"
    fi
done

# Install vim pathogen plugin handler: https://github.com/tpope/vim-pathogen
if [[ ! -f ~/.vim/autoload/pathogen.vim ]]; then
    mkdir -p ~/.vim/autoload ~/.vim/bundle
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

# Install git blame plugin: https://github.com/zivyangll/git-blame.vim
if [[ ! -d ~/.vim/bundle/git-blame.vim ]]; then
    cd ~/.vim/bundle
    git clone git@github.com:zivyangll/git-blame.vim.git
fi

# Install vundle plugin handler: https://github.com/VundleVim/Vundle.vim
if [[ ! -f ~/.vim/bundle/Vundle.vim ]]; then
    mkdir -p ~/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
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

# Install AWS CLI
if ! command -v aws > /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$HOME/Downloads/awscliv2.zip"
    unzip ~/Downloads/awscliv2.zip -d ~/Downloads
    sudo ~/Downloads/aws/install
fi

code_configs=($(find "$SCRIPT_DIR/vscode" -type f))
code_user_dir="$HOME/.config/Code/User"
mkdir -p $code_user_dir
for config in "${code_configs[@]}"; do
    filename=$(basename $config)
    if [[ ! -f "$code_user_dir/$filename" ]]; then
        sudo ln -s "$config" $code_user_dir
    else
        echo "Existing config $filename found in $code_user_dir, refusing to replace"
    fi
done
