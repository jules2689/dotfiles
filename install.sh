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

curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

source ~/.bash_profile
