#!/bin/bash
set -euo pipefail

source support/bash_output.sh

backup_secret_keys() {
	# Back up the keys file so its not removed
	if [ -f ${HOME}/dotfiles/.keys.bash ]; then
		echo "Backing up keys"
		cp ${HOME}/dotfiles/.keys.bash ${HOME}/.keys.bash
	fi
}

bash_profile() {
  rm -rf ~/.bash_profile
  ln -s $(pwd)/support/.bash_profile ~/.bash_profile
}

clean_dotfiles() {
  rm -rf ~/dotfiles
  mkdir ~/dotfiles
}

symlink_dotfiles() {
  mkdir -p "${HOME}/dotfiles/scripts/"
  pushd support/scripts
  shopt -s dotglob
  for f in *
  do
    echo "Symlinking $f to ${HOME}/dotfiles/scripts/$f"
    ln -sf "$(pwd)/$f" "${HOME}/dotfiles/scripts/$f"
  done
  shopt -u dotglob
  popd

  pushd support
  shopt -s dotglob
  for f in *.*.bash
  do
    echo "Symlinking $f to ${HOME}/dotfiles/$f"
    ln -sf "$(pwd)/$f" "${HOME}/dotfiles/$f"
  done
  shopt -u dotglob
  popd
}

vim() {
  ln -sf "$(pwd)"/support/.vim/* ~/.vim
  ln -sf "$(pwd)"/support/.vimrc ~/.vimrc
  ln -sf "$(pwd)"/support/.vimrc ~/.vim/init.vim

  mkdir -p ~/.config
  ln -sf ~/.vim ~/.config/nvim

  bash support/vim_plugins.sh
}

restore_secrets_keys() {
  touch ${HOME}/dotfiles/.keys.bash || exit

  # Restore any backed up keys
  if [ -f ${HOME}/.keys.bash ]; then
    echo "Restoring keys and removing backup"
    cp ${HOME}/.keys.bash ${HOME}/dotfiles/.keys.bash
    rm ${HOME}/.keys.bash
  fi
}

git_completion() {
  echo "Installing Git Completion"
  cp support/git_completion.sh ~/.git-completion.bash
}

ssh_config() {
  echo "Restoring SSH Config"
  cp support/ssh_config ~/.ssh/config
}

print_setup() {
  print_header
  echo -e "\x1b[36m${vert}\x1b[0m Installing dotfiles"
  print_footer
}

main() {
  add_phase backup_secret_keys     "Setup/Backup Secret Keys"
  add_phase bash_profile           "Setup Bash Profile"
  add_phase vim                    "Setup Vim"
  add_phase clean_dotfiles         "Clean dotfiles"
  add_phase symlink_dotfiles       "Symlink dotfiles to system"
  add_phase ssh_config             "Setup SSH Config"
  add_phase git_completion         "Setup Git Completion"
  add_phase restore_secrets_keys   "Restore Secrets Keys"

  print_setup
  run_phases
}
main "$@"

