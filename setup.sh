#!/bin/bash
set -euo pipefail

source support/bash_output.sh

install_homebrew() {
  bash provision/brew.sh
}

log_into_dropbox() {
  echo "Sign into Dropbox to synchronize 1Password. Enter anything to continue installation"
  read
}

install_mas_apps() {
  bash provision/mas.sh
}

restore_preferences() {
  cp provision/preferences/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
  defaults read com.googlecode.iterm2
}

install_crontab() {
  echo "Installing Crontab."
  bash provision/crontab.sh
}

install_dev() {
  echo "Setting up Dev."
  bash provision/dev.sh
}

install_ruby() {
  echo "Setting up Ruby."
  bash provision/ruby.sh
}

install_script() {
  echo "Running Dotfiles setup."
  bash install.sh
}

install_various() {
  echo "Finalizing computer setup."
  ln -sf "$(pwd)"/support/.mackup.cfg ~/.mackup.cfg
  bash provision/various.sh
}

restore_ssh_gpg() {
  echo "Get the SSH keys from 1Password"
  echo "Put them in ~/.ssh. Write anything to continue"
  read

  echo "Get the GPG keys from 1Password"
  echo "Put the files in ~/Desktop/gpg. Write anything to continue"
  read

  gpg --import ~/Desktop/gpg/julian-secret-gpg.key
  gpg --import-ownertrust ~/Desktop/gpg/julian-ownertrust-gpg.txt

  rm -rf ~/Desktop/gpg

  git config --global commit.gpgsign true
  git config --global user.signingkey CAD41019602B5DC8
}

print_setup() {
  print_header
  echo -e "\x1b[36m${vert}\x1b[0m  ____       _   _   _                              ____                            _              "
  echo -e "\x1b[36m${vert}\x1b[0m / ___|  ___| |_| |_(_)_ __   __ _   _   _ _ __    / ___|___  _ __ ___  _ __  _   _| |_ ___ _ __   "
  echo -e "\x1b[36m${vert}\x1b[0m \___ \ / _ | __| __| | '_ \ / _' | | | | | '_ \  | |   / _ \| '_ ' _ \| '_ \| | | | __/ _ | '__|  "
  echo -e "\x1b[36m${vert}\x1b[0m  ___) |  __| |_| |_| | | | | (_| | | |_| | |_) | | |__| (_) | | | | | | |_) | |_| | ||  __| |     "
  echo -e "\x1b[36m${vert}\x1b[0m |____/ \___|\__|\__|_|_| |_|\__, |  \__,_| .__/   \____\___/|_| |_| |_| .__/ \__,_|\__\___|_|     "
  echo -e "\x1b[36m${vert}\x1b[0m                             |___/        |_|                          |_|                         "
  print_footer
}

print_finalization() {
  print_header
  echo -e "\x1b[36m${vert}\x1b[0m How to finalize the installation"
  echo -e "\x1b[36m${vert}\x1b[0m ================================="
  echo -e "\x1b[36m${vert}\x1b[0m 1. Sign into Google Drive and Dropbox."
  echo -e "\x1b[36m${vert}\x1b[0m 2. Sign into Chrome, Spotify, Slack, Xcode."
  echo -e "\x1b[36m${vert}\x1b[0m 3. Fix the screenshot shortcut in keyboard settings."
  print_footer
}

main() {
  add_phase install_homebrew      "Install Homebrew & Packages"
  add_phase log_into_dropbox      "Log into Dropbox"
  add_phase install_mas_apps      "Install Mac App Store Apps"
  add_phase restore_preferences   "Restore App Settings"
  add_phase install_dev           "Install Dev"
  add_phase install_ruby          "Install Ruby"
  add_phase install_crontab       "Install Crontab"
  add_phase install_script        "Run Install Script for Dotfile"
  add_phase install_various       "Finalize installation"

  print_setup
  run_phases
  print_finalization
}
main "$@"
