#!/bin/bash

dev() {
	exec 9<> "$HOME/dotfiles/fd_9"
	ruby --disable-gems "$HOME/dotfiles/scripts/dev.rb" "$@"
	eval $(cat $HOME/dotfiles/fd_9)
	exec 9>&-
}