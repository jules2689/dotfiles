#!/bin/bash

# Back up the keys file so its not removed
if [ -f ${HOME}/dotfiles/.keys.bash ]; then
  echo "Backing up keys"
  cp ${HOME}/dotfiles/.keys.bash ${HOME}/.keys.bash
fi

# Remove any dotfiles installed
rm -r ~/dotfiles
mkdir ~/dotfiles

# Symlink all files
shopt -s dotglob
for f in *.*.bash
do
  echo "Symlinking $f to ${HOME}/dotfiles/$f"
  ln -sf "$(pwd)/$f" "${HOME}/dotfiles/$f"
done
shopt -u dotglob

# Remove current bash profile, symlink the one from this repo
rm ~/.bash_profile
ln -s $(pwd)/.bash_profile ~/.bash_profile

# Create the keys file
touch ${HOME}/dotfiles/.keys.bash || exit

# Restore any backed up keys
if [ -f ${HOME}/.keys.bash ]; then
  echo "Restoring keys and removing backup"
  cp ${HOME}/.keys.bash ${HOME}/dotfiles/.keys.bash
  rm ${HOME}/.keys.bash
fi

# Git Completion Helpers
cp support/git_completion.sh ~/.git-completion.bash
chmod +x ~/.git-completion.bash

# Source the bash profile
source ~/.bash_profile

# Copy over SSH Config
cp support/ssh_config ~/.ssh/config
