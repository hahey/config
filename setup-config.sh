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

conky_download(){
    wget "https://github.com/brndnmtthws/conky/releases/download/v1.11.5/conky-x86_64.AppImage"
}

declare -A apps=( ["Boostio"]=boostio_download ["Dropbox"]=dropbox_download ["Chrome"]=chrome_download ["Transcribe"]=transcribe_download ["Conky"]=conky_download)

if ask_continue "Dropbox, Boostnote, Chrome, Transcribe, Conky download"
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
    SPEED="/.netspeed"
    [[ -e $PWD$SPEED ]] || python3 -m venv $PWD$SPEED
    source $SPEED/bin/activate
    pip install -U pip speedtest-cli
}

youcompleteme_install(){
    SPEED="/.netspeed"
    [[ -e $PWD$SPEED ]] || python3 -m venv $PWD$SPEED

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
    I3WMCONF="/i3config"
    POLYBAR="/polybar"
    ZSHRC="/zshrc"
    ZSHLOC="/zshrc.local"
    CONKY="/conky.conf"
    ROFI="/.config/rofi"

    mkdir -p ~/.config/conky
    if [[ -h $HOME/.config/conky/conky.conf ]]
    then
        rm -r $HOME/.config/conky/conky.conf
    fi
    ln -s $PWD$CONKY $HOME/.config/conky/conky.conf

    mkdir -p ~/.config/i3
    if [[ -e $HOME/.config/i3/config ]]
    then
        rm -r $HOME/.config/i3/config
    fi
    ln -s $PWD$I3WMCONF $HOME/.config/i3/config

    if [[ -h $HOME$ROFI ]]
    then
        rm -r $HOME$ROFI
    fi
    ln -s $PWD/rofi $HOME$ROFI

    if [[ -e ~/.config$POLYBAR ]]
    then
        rm -r ~/.config$POLYBAR
    fi
    ln -s $PWD$POLYBAR ~/.config$POLYBAR

    mkdir -p ~/.config/nvim
    if [[ -h ~/.config/nvim/init.vim ]]
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

    if [[ -h ~/.vimrc ]]
    then
        rm ~/.vimrc
    fi
    ln -s $PWD$VIMRC ~/.vimrc

    if ask_continue "Vim Plugin install?"
    then
        vim +PluginInstall +qall
    fi

    # [[ -d powerlevel10k ]] || git clone https://github.com/romkatv/powerlevel10k.git

    if [[ -h $HOME/.zshrc ]]
    then
        rm $HOME/.zshrc
    fi
    if [[ -h $HOME/.zshrc.local ]]
    then
        rm $HOME/.zshrc.local
    fi
    if [[ -h $HOME/.zprezto ]]
    then
        rm $HOME/.zprezto
    fi

    [[ -d prezto ]] || git clone --recursive https://github.com/sorin-ionescu/prezto.git

    ln -s $PWD/prezto "$HOME/.zprezto"

    ln -s $PWD$ZSHRC $HOME/.zshrc
    ln -s $PWD$ZSHLOC $HOME/.zshrc.local

    chsh -s /bin/zsh

    mkdir -p ~/.local/share/konsole
    [[ -e $HOME/.local/share/konsole/profile ]] && rm $HOME/.local/share/konsole/profile
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
