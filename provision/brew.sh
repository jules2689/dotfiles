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
echo "Brew Cask: Tapping caskroom/cask"
brew tap caskroom/cask 1>/dev/null

packages=(
  argon/mas/mas
  brew-cask
  cmake
  fswatch
  gcc
  gnupg
  gnupg2
  go
  imagemagick
  mercurial
  mysql
  node
  packer
  phantomjs
  postgresql
  python
  redis
  subversion
  wget
)

# Install Brew Packages
for pkg in $packages; do
  if brew list -1 | grep -q "^${pkg}\$"; then
    echo "Brew: Package '$pkg' is already installed"
  else
    echo "Brew: Installing '$pkg'"
    brew install $pkg 1>/dev/null
  fi
done

packages=(
  1password
  adium
  charles
  dash
  dropbox
  flux
  google-chrome
  google-drive
  heroku-toolbelt
  iterm2
  java
  karabiner
  licecap
  sketch
  skype
  slack
  spotify
  steam
  sublime-text
  vmware-fusion
)

# Install Brew Casks
for pkg in $packages; do
  if brew cask info $pkg | grep -q "Not installed"; then
    echo "Brew Cask: Installing '$pkg'"
    brew cask install --appdir="/Applications" $pkg 1>/dev/null
  else
    echo "Brew Cask: Package '$pkg' is already installed"
  fi
done
