#!/bin/bash

VIM="/vim"
VIMRC="/vimrc"
PROFILE="/profile"

rm -rf ~/.vim
ln -s $PWD$VIM ~/.vim
ln -s $PWD$VIMRC ~/.vimrc
mkdir -p ~/.local/share/konsole
ln -s $PWD$PROFILE ~/.local/share/konsole/profile
cd vim
./pathogen-update.sh
