#!/bin/bash

# Install Xcode Command Line Tools
xcode-select -p
if [[ $? -ne 0 ]]; then
  echo "Installing Command Line Tools"
  # Create the placeholder file that's checked by CLI updates' .dist code in Apple's SUS catalog
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  # find the CLI Tools update
  PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
  softwareupdate -i "$PROD" -v # install it
else
  echo "Command Line Tools already installed"
fi

# Download Repo
mkdir -p ~/Development/personal/other
cd ~/Development/personal/other
git clone https://github.com/jules2689/dotfiles.git
cd ~/Development/personal/other/dotfiles

# Setup Proper Paths and Remotes
git remote set-url origin git@github.com:jules2689/dotfiles.git

# Run Setup
~/Development/personal/other/dotfiles/setup.sh
