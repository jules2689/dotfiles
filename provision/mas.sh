#!/bin/bash

if [[ ! -d /Applications/Xcode.app ]]; then
  mas install 497799835
fi

if [[ ! -d /Applications/Write.app ]]; then
  mas install 848311469
fi

if [[ ! -d /Applications/Pocket.app ]]; then
  mas install 568494494
fi

if [[ ! -d /Applications/GIF\ Brewery\ 3.app ]]; then
  mas install 1081413713
fi

if [[ ! -d /Applications/Irvue.app ]]; then
  mas install 1039633667
fi

outdated=$(mas outdated)
if [[ -z "${outdated// }" ]]; then
  echo "MAS: apps up to date"
else
  echo "Need to update apps"
  mas upgrade
fi