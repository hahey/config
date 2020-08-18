#!/usr/bin/env bash

set -eu

ask_continue(){
    local YES
    read -p "$1 [Y/n]? " YES; echo
    [[ -z $YES || $YES =~ ^[Yy]$ ]]
}

boostio_download(){
    wget -O ./boostnote.deb "https://github.com/BoostIO/BoostNote.next/releases/latest/download/boost-note-linux.deb"
}

dropbox_download(){
    wget -O ./dropbox.deb "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb"
}

chrome_download(){
    wget -O ./chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
}

transcribe_download(){
    wget "https://www.seventhstring.com/xscribe/xsc64setup.tar.gz"
    tar -xf xsc64setup.tar.gz
}

declare -A apps=( ["Boostio"]=boostio_download ["Dropbox"]=dropbox_download ["Chrome"]=chrome_download ["Transcribe"]=transcribe_download)

if ask_continue "Dropbox, Boostnote, Chrome, Transcribe download"
then
    for app in "${!apps[@]}"
    do
        if ask_continue $app
        then
            ${apps[$app]}
        fi
    done
fi

package_install(){
    sudo apt update && sudo apt upgrade
    sed 's/# .*//' apt.list| xargs sudo apt install -y
}
if ask_continue "Debian package install"
then
    package_install
fi

netspeed_install(){
    [[ -e $PWD$SPEED ]] || python3 -m venv $PWD$SPEED
    source $PWD$SPEED/bin/activate
    pip install -U pip speedtest-cli
}

youcompleteme_install(){
        CONF=$PWD
        cd ~/.vim/bundle/YouCompleteMe
        source $CONF$SPEED/bin/activate
        python3 install.py --clangd-completer
        cd $CONF
}

texlive_packages_install(){
    [[ -d "$HOME/texmf" ]] || tlmgr init-usertree
    [[ -e "$PWD/update-tlmgr-latest.sh" ]] || wget https://mirror.informatik.hs-fulda.de/tex-archive/systems/texlive/tlnet/update-tlmgr-latest.sh
    chmod u+x update-tlmgr-latest.sh
    PATH="$PATH:$HOME/texmf" ./update-tlmgr-latest.sh
    tlmgr install german geometry
}

config_setup_from_repo(){
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
    if [[ -e ~/.config/nvim/init.vim ]]
    then
        rm -r ~/.config/nvim/init.vim
    fi
    ln -s $PWD$NVIMCONF ~/.config/nvim/init.vim

    mkdir -p vim
    cd vim
    [[ -d Vundle.vim ]] || git clone https://github.com/VundleVim/Vundle.vim.git
    mkdir -p ~/.vim/bundle
    [[ -e ~/.vim/bundle/Vundle.vim ]] || ln -s $PWD$VUNDLE ~/.vim/bundle/Vundle.vim
    cd ..

    rm ~/.conkyrc
    mkdir -p ~/.config/conky
    [[ -e ~/.config/conky/conky.conf ]] || ln -s $PWD$CONKY ~/.config/conky/conky.conf

    rm ~/.vimrc
    ln -s $PWD$VIMRC ~/.vimrc

    if ask_continue "Vim Plugin install?"
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

    if ask_continue "netspeed (speedtest-cli) install"
    then
        netspeed_install
    fi

    if ask_continue "YouCompleteMe install"
    then
        youcompleteme_install
    fi

    if ask_continue "texlive packages install"
    then
        texlive_packages_install
    fi
}

if ask_continue "Config setup"
then
    config_setup_from_repo
fi
