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
for pkg in brew-cask cmake fswatch gcc gnupg gnupg2 go imagemagick mercurial mysql node packer phantomjs postgresql python redis subversion wget; do
  if brew list -1 | grep -q "^${pkg}\$"; then
    echo "Package '$pkg' is already installed"
  else
    brew install $pkg
  fi
done

# Install Brew Casks
for pkg in 1password adium dropbox flux google-chrome google-drive java sketch skype slack spotify steam sublime-text vmware-fusion; do
  if brew cask info $pkg | grep -q "Not installed"; then
    brew cask install --appdir="/Applications" $pkg
  else
    echo "Cask Package '$pkg' is already installed"
  fi
done
