Dotfiles
===

My collection of dotfiles and setup scripts. Current OS X focussed.

Install Dotfiles
===

`./install.sh` will install bash profiles, source directories, and setup symlinks.

Setup a new computer
===

It is not required to download this repo before running this command. It is meant to be run on a fresh install of Mac OS X.

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

### Git Restore

 - Under `support` there is a ruby script that will backup a JSON representation of the repo structure.
 - Running `ruby git_backup.rb [BACKUP_PATH]` will back up the JSON to that path
 - This is setup in a cron job
 - To restore run `ruby git_backup.rb restore [PATH_TO_JSON]`. This will create all directories and clone all the repos.
