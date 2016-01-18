# Install Brew Packages
which -s brew
if [[ $? -ne 0 ]]; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
else
  brew update
fi

# Tap Cask
brew tap caskroom/cask

# Install Brew Packages
for pkg in brew-cask gnupg gnupg2 gcc wget cmake mercurial subversion redis postgresql python mysql packer phantomjs node imagemagick fswatch go; do
  if brew list -1 | grep -q "^${pkg}\$"; then
    echo "Package '$pkg' is already installed"
  else
    brew install $pkg
  fi
done

# Install Brew Casks
for pkg in java google-chrome vmware-fusion spotify 1password adium sublime-text flux google-drive dropbox omnigraffle slack sketch skype steam; do
  if brew cask info $pkg | grep -q "Not installed"; then
    brew cask install --appdir="/Applications" $pkg
  else
    echo "Cask Package '$pkg' is already installed"
  fi
done
