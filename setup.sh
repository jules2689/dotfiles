#!/bin/bash
set -euo pipefail

source support/bash_output.sh

install_homebrew() {
  bash provision/brew.sh
}

install_crontab() {
  echo "Installing Crontab."
  bash provision/crontab.sh
}

install_ssh() {
  if [[ -a ~/.ssh/id_rsa ]]; then
    success "It looks like SSH keys are already setup."
    return
  fi
  echo "Generating SSH Keys."
  bash provision/ssh.sh
}

install_ruby() {
  if [ $(which ruby) != '/usr/bin/ruby' ]; then
    success "It looks like Ruby is already setup."
    return
  fi

  echo "Installing Ruby..."
  bash provision/rbenv.sh
}

install_script() {
  echo "Running Dotfiles setup."
  bash install.sh
}

install_various() {
  echo "Finalizing computr setup."
  bash various.sh
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
  echo -e "\x1b[36m${vert}\x1b[0m 1. A public SSH key was copied to the clipboard, add it to Github."
  echo -e "\x1b[36m${vert}\x1b[0m 2. Sign into Google Drive and Dropbox."
  echo -e "\x1b[36m${vert}\x1b[0m 3. 1Password should be setup with the vault on Dropbox."
  echo -e "\x1b[36m${vert}\x1b[0m 4. Sign into Chrome, Spotify, Slack, Xcode."
  echo -e "\x1b[36m${vert}\x1b[0m 5. Download WriteApp from Mac App Store, point it to Google Drive"
  echo -e "\x1b[36m${vert}\x1b[0m 6. Download GPG Keychain, set it up."
  echo -e "\x1b[36m${vert}\x1b[0m 7. Restore Git repos from Dropbox > Backup > repo_list.json."
  print_footer
}

main() {
  add_phase install_homebrew "Install Homebrew & Packages"
  add_phase install_ssh      "Install SSH"
  add_phase install_ruby     "Install Ruby"
  add_phase install_crontab  "Install Crontab"
  add_phase install_script   "Run Install Script for Dotfile"
  add_phase install_various  "Finalize installation"

  print_setup
  run_phases
  print_finalization
}
main "$@"
