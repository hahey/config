#!/usr/bin/env bash

set -eu

read -p "Dropbox, Boostnote, Chrome download?" -n 1 YES
echo
if [[ $YES =~ ^[Yy]$ ]]
then
    wget -O ./boostnote.deb "https://github.com/BoostIO/BoostNote.next/releases/latest/download/boost-note-linux.deb"
    wget -O ./dropbox.deb "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb"
    wget -O ./chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
fi

read -p "Debian package install?" -n 1 YES
echo
if [[ $YES =~ ^[Yy]$ ]]
then
    sed 's/# .*//' apt.list| xargs sudo apt install -y --allow-downgrades
fi

read -p "Config setup?" -n 1 YES

echo
if [[ $YES = ^[Yy]$ ]]
then
    exit 0
fi

echo configuring
VUNDLE="/Vundle.vim"
VIMRC="/vimrc"
NVIMCONF="/init.vim"
PROFILE="/profile"
ZSHRC="/zshrc"
ZSHLOC="/zshrc.local"
CONKY="/conkyrc"
SPEED="/.netspeed"

mkdir -p ~/.config/nvim
rm -r ~/.config/nvim/init.vim
ln -s $PWD$NVIMCONF ~/.config/nvim/init.vim

mkdir -p vim
cd vim
[[ -d Vundle.vim ]] || git clone https://github.com/VundleVim/Vundle.vim.git
mkdir -p ~/.vim/bundle
[[ -e ~/.vim/bundle/Vundle.vim ]] || ln -s $PWD$VUNDLE ~/.vim/bundle/Vundle.vim
cd ..

rm ~/.conkyrc
ln -s $PWD$CONKY ~/.conkyrc

rm ~/.vimrc
ln -s $PWD$VIMRC ~/.vimrc

read -p "Vim Plugin install?" -n 1 YES
echo
if [[ $YES =~ ^[Yy]$ ]]
then
    vim +PluginInstall +qall
fi

[[ -d powerlevel9k ]] || git clone https://github.com/bhilburn/powerlevel9k.git

rm ~/.zshrc
rm ~/.zshrc.local
ln -s $PWD$ZSHRC ~/.zshrc
ln -s $PWD$ZSHLOC ~/.zshrc.local

mkdir -p ~/.local/share/konsole
rm ~/.local/share/konsole/profile
ln -s $PWD$PROFILE ~/.local/share/konsole/profile

read -p "netspeed (speedtest-cli) install?" -n 1 YES
echo
if [[ $YES =~ ^[Yy]$ ]]
then
    [[ -e $PWD$SPEED ]] || python3 -m venv $PWD$SPEED
    source $PWD$SPEED/bin/activate
    pip install -U pip speedtest-cli
fi


#temporal patch for go
temporal_patch() {
    wget -O go.tar.gz https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz
    tar -xvf go.tar.gz -C $HOME/go
    GO114MODULE=on GOROOT="$HOME/go/go" PATH="${GOROOT}/bin:${PATH}" go get golang.org/x/tools/gopls@latest
}

read -p "YouCompleteMe install?" -n 1 YES
echo
if [[ $YES =~ ^[Yy]$ ]]
then
    temporal_patch

    CONF=$PWD
    cd ~/.vim/bundle/YouCompleteMe
    source $CONF$SPEED/bin/activate
    GOROOT="$HOME/go/go" PATH="${GOROOT}/bin:${PATH}" python3 install.py --go-completer --clangd-completer
    cd $CONF
fi
