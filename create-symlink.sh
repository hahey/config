#!/bin/bash

VIM="/vim"

rm -rf ~/.vim
ln -s $PWD$VIM ~/.vim
mkdir -p ~/.local/share/konsole
ln -s profile ~/.local/share/konsole
cd vim
./pathogen-update.sh
