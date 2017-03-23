#!/bin/bash

# Install Brew Packages
which -s brew
if [[ $? -ne 0 ]]; then
  echo "Installing Brew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
else
  echo "Brew is already installed."
fi

# Tap Cask
if brew tap | grep -q caskroom; then
  echo "Brew cask already setup"
else
  echo "Brew Cask: Tapping caskroom/cask"
  brew tap caskroom/cask 1>/dev/null
  brew tap caskroom/versions 1>/dev/null
fi

packages=(
  argon/mas/mas
  cmake
  fswatch
  gcc
  gnupg
  gnupg2
  go
  imagemagick
  mackup
  mercurial
  mysql
  neovim/neovim/neovim
  node
  packer
  phantomjs
  postgresql
  python
  redis
  ruby-install
  subversion
  wget
)

brew_list=$(brew list -1)
for pkg in "${packages[@]}"
do
  actual_package_name=${pkg##*\/}
  if [[ ! ($brew_list =~ "$actual_package_name") ]]; then
    echo "Brew: Installing '$pkg'"
    brew install $pkg 1>/dev/null
  fi
done

cask_packages=(
  1password
  adium
  charles
  dash
  docker
  dropbox
  flux
  google-chrome
  google-drive
  gpgtools
  iterm2
  java
  karabiner
  licecap
  little-snitch
  sequel-pro
  sketch
  skype
  slack
  spotify
  steam
  sublime-text
  telegram
  viscosity
  vmware-fusion
)

cask_brew_list=$(brew cask list -1)
for pkg in "${cask_packages[@]}"
do
  if [[ !($cask_brew_list =~ "$pkg") ]]; then
    echo "Brew Cask: Installing '$pkg'"
    brew cask install --appdir="/Applications" $pkg 1>/dev/null
  fi
done
