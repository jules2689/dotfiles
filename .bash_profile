source ~/.profile
source ~/dotfiles/.github.bash
source ~/dotfiles/.rvm.bash
source ~/dotfiles/.aliases.bash
source ~/dotfiles/.keys.bash

export PATH="/Applications/Postgres.app/Contents/MacOS/bin:$PATH"
export PATH="/Applications/VMware Fusion.app/contents/Library:$PATH"
export PATH=/user/local:$PATH
export PATH=/usr/local/git/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH="~/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export JAVA_HOME=$(/usr/libexec/java_home)

eval "$(ssh-agent -s)" > /dev/null 2>&1
ssh-add ~/.ssh/id_rsa > /dev/null 2>&1
