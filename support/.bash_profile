source ~/.profile
source ~/dotfiles/.github.bash
source ~/dotfiles/.rbenv.bash
source ~/dotfiles/.aliases.bash
source ~/dotfiles/.keys.bash

export PATH="/Applications/Postgres.app/Contents/MacOS/bin:$PATH"
export PATH="/Applications/VMware Fusion.app/contents/Library:$PATH"
export PATH=/user/local:$PATH
export PATH=/usr/local/git/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH="~/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

export JAVA_HOME=$(/usr/libexec/java_home)
export ANDROID_HOME="/usr/local/opt/android-sdk"
export GOPATH="$HOME/golang"
export PATH="$PATH:$GOPATH/bin"

# SSH Identity
eval "$(ssh-agent -s)" > /dev/null 2>&1
ssh-add ~/.ssh/id_rsa > /dev/null 2>&1

[ -f ~/.env.sh ] && source ~/.env.sh

# Added by dev
[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh
[ -f /usr/local/share/chruby/chruby.sh ] && source /usr/local/share/chruby/chruby.sh
[ -f /usr/local/share/chruby/auto.sh ] && source /usr/local/share/chruby/auto.sh
RUBIES+=(/usr/local/Cellar/shopify-ruby/*)
