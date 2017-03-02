#!/bin/bash

if [[ ! -d /Applications/Xcode.app ]]; then
  echo "Installing Xcode"
  mas install 497799835
fi

if [[ ! -d /Applications/Write.app ]]; then
  echo "Installing Write app"
  mas install 848311469
fi

if [[ ! -d /Applications/Pocket.app ]]; then
  echo "Installing Pocket"
  mas install 568494494
fi

if [[ ! -d /Applications/GIF\ Brewery\ 3.app ]]; then
  echo "Installing Gif Brewery 3"
  mas install 1081413713
fi

if [[ ! -d /Applications/Irvue.app ]]; then
  echo "Installing Irvue"
  mas install 1039633667
fi

 echo "Finished Installing stuff"

outdated=$(mas outdated)
if [[ -z "${outdated// }" ]]; then
  echo "MAS: apps up to date"
else
  echo "Need to update apps"
  mas upgrade
fi
