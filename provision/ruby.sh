#!/bin/bash

echo "Installing chruby & ruby-install"
brew update
brew install chruby
brew install ruby-install

echo "Setting up Ruby"
ruby-install 2.3.1
