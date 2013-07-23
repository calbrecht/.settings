#!/bin/bash

SETTINGS=$SETTINGS

function surm()
{
    [[ $(sudo test -e $1; echo $?) = 0 ||
       $(sudo test -L $1; echo $?) = 0 ]] && sudo rm -rf $1
}

surm $HOME/.Xdefaults
surm $HOME/.Xresources
ln -s $SETTINGS/Xresources $HOME/.Xresources

surm $HOME/.bashrc
ln -s $SETTINGS/bash/bashrc $HOME/.bashrc

surm $HOME/.vimrc
ln -s $SETTINGS/vim/.vimrc $HOME/.vimrc

surm $HOME/.urxvt
ln -s $SETTINGS/urxvt $HOME/.urxvt

surm $HOME/.xmonad
ln -s $SETTINGS/xmonad $HOME/.xmonad

surm /root/.bashrc
sudo ln -s $HOME/.bashrc /root/.bashrc

surm /root/.vimrc
sudo ln -s $HOME/.vimrc /root/.vimrc

unset surm

exit 0
