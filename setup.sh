#!/bin/bash

# TODO: Write App, GPG Keychain
# TODO: Licenses

set -eo pipefail
shopt -s nullglob

# Install and setup Homebrew & Homebrew Cask w/Packages & Casks
bash provision/brew.sh

# Install latest Ruby
bash provision/rvm.sh

# Generate and Install SSH Keys
bash provision/ssh.sh

# Install Dotfiles
~/Development/personal/other/dotfiles/install.sh
