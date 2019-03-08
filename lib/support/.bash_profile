source ~/dotfiles/.github.bash
source ~/dotfiles/.ruby.bash
source ~/dotfiles/.aliases.bash
source ~/dotfiles/.keys.bash
source ~/.bashrc

export JAVA_HOME=$(/usr/libexec/java_home)
export ANDROID_HOME="/usr/local/opt/android-sdk"
export GOPATH="$HOME"

export PATH="/Applications/Postgres.app/Contents/MacOS/bin:$PATH"
export PATH="/user/local:$PATH"
export PATH="/usr/local/git/bin:$PATH"
export PATH="~/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$PATH:$GOPATH/bin"
export PATH="/usr/local/bin:$PATH"

# Link Sublime to /usr/local/bin
if [ ! -f /usr/local/bin/subl ]; then
  ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
fi

# SSH Identity
eval "$(ssh-agent -s)" > /dev/null 2>&1
ssh-add ~/.ssh/id_rsa > /dev/null 2>&1

# GPG
export GPG_TTY=$(tty)
[ -f ~/.gpg-agent-info ] && source ~/.gpg-agent-info
if [ -S "${GPG_AGENT_INFO%%:*}" ]; then
  export GPG_AGENT_INFO
else
  eval $( gpg-agent --daemon --write-env-file ~/.gpg-agent-info  > /dev/null 2>&1 )
fi
