#!/bin/bash

echo "Installing Rbenv"
brew update
brew install rbenv
brew install ruby-build

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

echo "Setting up Rbenv"
rbenv install -s 2.2.2
rbenv rehash
rbenv global 2.2.2