#!/bin/bash

VUNDLE="/Vundle.Vim"
VIMRC="/vimrc"
PROFILE="/profile"
ZSHRC="/zshrc"
ZSHLOC="/zshrc.local"

rm -rf ~/.vim
mkdir vim
cd vim
git clone https://github.com/VundleVim/Vundle.vim.git
ln -s $PWD$VUNDLE ~/.vim/bundle/Vundle.vim
cd ..

ln -s $PWD$VIMRC ~/.vimrc

git clone https://github.com/bhilburn/powerlevel9k.git

ln -s $PWD$ZSHRC ~/.zshrc
ln -s $PWD$ZSHLOC ~/.zshrc.local

mkdir -p ~/.local/share/konsole
ln -s $PWD$PROFILE ~/.local/share/konsole/profile

