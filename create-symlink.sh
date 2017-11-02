#!/bin/bash

VUNDLE="/Vundle.vim"
VIMRC="/vimrc"
PROFILE="/profile"
ZSHRC="/zshrc"
ZSHLOC="/zshrc.local"

rm -rf ~/.vim
mkdir vim
cd vim
git clone https://github.com/VundleVim/Vundle.vim.git
mkdir -p ~/.vim/bundle
ln -s $PWD$VUNDLE ~/.vim/bundle/Vundle.vim
cd ..

rm ~/.vimrc
ln -s $PWD$VIMRC ~/.vimrc
vim +PluginInstall +qall

git clone https://github.com/bhilburn/powerlevel9k.git

rm ~/.zshrc
rm ~/.zshrc.local
ln -s $PWD$ZSHRC ~/.zshrc
ln -s $PWD$ZSHLOC ~/.zshrc.local

mkdir -p ~/.local/share/konsole
ln -s $PWD$PROFILE ~/.local/share/konsole/profile


