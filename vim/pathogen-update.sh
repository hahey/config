#!/bin/bash

BUNDLE_DIR=bundle
AUTOLOAD_DIR=autoload
PATHOGEN=autoload/pathogen.vim
if [ ! -d "$AUTOLOAD_DIR$" ]; then
    mkdir -p "$AUTOLOAD_DIR"
fi
if [ ! -d "$BUNDLE_DIR$" ]; then
    mkdir -p "$BUNDLE_DIR"
fi
if [ ! -f "$PATHOGEN" ]; then
curl -LSso "$PATHOGEN" https://tpo.pe/pathogen.vim
fi

for i in ~/.vim/bundle/*; do git -C $i pull; done
