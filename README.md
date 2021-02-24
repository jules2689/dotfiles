Dotfiles
===

My collection of dotfiles and setup scripts. Current OS X focussed.

Install Dotfiles
===

`bin/install` will setup and install bash profiles, source directories, and setup symlinks.

Setup a new computer
===

It is not required to download this repo before running this command. It is meant to be run on a fresh install of Mac OS X.

`bash <(curl -s https://raw.githubusercontent.com/jules2689/dotfiles/main/bin/download)`

This command will download the `bin/download` file. This will clone this repo temporarily and install using `bin/install`.

1. Will install brew and brew cask. 
2. Will install packages and casks
3. Will install various scripts and the latest Ruby
4. Create a `.ssh` directory and generates a private/public keypair. This also copies the public key to the clipboard.
5. Setup `.bash_profile`

### Brew Packages & Casks

This will install a number of brew and cask packages listed [here](https://github.com/jules2689/dotfiles/blob/main/Brewfile)
