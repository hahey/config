#!/bin/bash

VIM="/vim"
VIMRC="/vimrc"
PROFILE="/profile"
ZSHRC="/zshrc"
ZSHLOC="/zshrc.local"

rm -rf ~/.vim
ln -s $PWD$VIM ~/.vim
ln -s $PWD$VIMRC ~/.vimrc

ln -s $PWD$ZSHRC ~/.zshrc
ln -s $PWD$ZSHLOC ~/.zshrc.local

mkdir -p ~/.local/share/konsole
ln -s $PWD$PROFILE ~/.local/share/konsole/profile
cd vim
./pathogen-update.sh
