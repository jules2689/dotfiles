Dotfiles
===

My collection of dotfiles and setup scripts. Current OS X focussed.

Install Dotfiles
===

`./install.sh` will install bash profiles, source directories, and setup symlinks.

Setup a new computer
===

`bash <(curl -s https://raw.githubusercontent.com/jules2689/dotfiles/master/download.sh)`

This command will download the `download.sh` file. This will make sure that XCode command line tools are installed, then clone this repo. After cloning, it will run `setup.sh`

*IMPORTANT:* This command will require root access and ask for the admin password. Homebrew requires this access. either sudo the above command - or enter the sudo password multiple times.

`setup.sh` consists of a number of installation steps. 

1. Will install brew and brew cask. 
2. Will install packages and casks
3. Will install RVM and the latest stable Ruby
4. Create a `.ssh` directory and generates a private/public keypair. This also copies the public key to the clipboard.
5. Runs `install.sh` to setup bash profiles

### Brew Packages

  - brew-cask 
  - gnupg 
  - gnupg2 
  - gcc 
  - wget 
  - cmake 
  - mercurial 
  - subversion 
  - redis 
  - postgresql 
  - python 
  - mysql 
  - packer 
  - phantomjs 
  - node 
  - imagemagick 
  - fswatch 
  - go

### Brew Casks

 - java 
 - google-chrome 
 - vmware-fusion
 - spotify 
 - 1password 
 - adium 
 - sublime-text 
 - flux 
 - google-drive 
 - dropbox 
 - omnigraffle 
 - slack 
 - sketch 
 - skype 
 - steam

### TODO

 - Experiment with auto-installing licenses and signins using eJSON
 - ABC the above lists
 - Better output and finalize with a list of TODOs after these scripts run
