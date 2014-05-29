#!/bin/bash

rm -r ~/dotfiles
mkdir ~/dotfiles

shopt -s dotglob
for f in *.*.bash
do
  echo "Symlinking $f to ${HOME}/dotfiles/$f"
  ln -sf "$(pwd)/$f" "${HOME}/dotfiles/$f"
done
shopt -u dotglob

rm ~/.bash_profile
ln -s $(pwd)/.bash_profile ~/.bash_profile

touch ${HOME}/dotfiles/.keys.bash || exit

source ~/.bash_profile
