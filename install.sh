#!/bin/bash

if [ -f ${HOME}/dotfiles/.keys.bash ]; then
  echo "Backing up keys"
  cp ${HOME}/dotfiles/.keys.bash ${HOME}/.keys.bash
fi

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

if [ -f ${HOME}/.keys.bash ]; then
  echo "Restoring keys and removing backup"
  cp ${HOME}/.keys.bash ${HOME}/dotfiles/.keys.bash
  rm ${HOME}/.keys.bash
fi

curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

source ~/.bash_profile
