#!/usr/bin/env bash

set -eu

read -p "Debian package install?" -n 1 YES

echo
if [[ $YES =~ ^[Yy]$ ]]
then
    wget -O ./boostnote.deb "https://github.com/BoostIO/BoostNote.next/releases/latest/download/boost-note-linux.deb"
    wget -O ./dropbox.deb "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb"
    sed 's/# .*//' apt.list| xargs sudo apt install -y
fi

read -p "Config setup?" -n 1 YES

echo
if [[ $YES = ^[Yy]$ ]]
then
    exit 0
fi

VUNDLE="/Vundle.vim"
VIMRC="/vimrc"
PROFILE="/profile"
ZSHRC="/zshrc"
ZSHLOC="/zshrc.local"
CONKY="/conkyrc"

rm -rf ~/.vim
mkdir -p vim
cd vim
[[ -d Vundle.vim ]] || git clone https://github.com/VundleVim/Vundle.vim.git
mkdir -p ~/.vim/bundle
ln -s $PWD$VUNDLE ~/.vim/bundle/Vundle.vim
cd ..

rm ~/.conkyrc
ln -s $PWD$CONKY ~/.conkyrc

rm ~/.vimrc
ln -s $PWD$VIMRC ~/.vimrc
vim +PluginInstall +qall

[[ -d powerlevel9k ]] || git clone https://github.com/bhilburn/powerlevel9k.git

rm ~/.zshrc
rm ~/.zshrc.local
ln -s $PWD$ZSHRC ~/.zshrc
ln -s $PWD$ZSHLOC ~/.zshrc.local

mkdir -p ~/.local/share/konsole
rm ~/.local/share/konsole/profile
ln -s $PWD$PROFILE ~/.local/share/konsole/profile

exec zsh
mkvenv3
pip install speedtest-cli
cd ~/.vim/bundle/YouCompleteMe
python3 install.py --all
deactivate
