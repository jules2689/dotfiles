source ~/dotfiles/.github.bash
source ~/dotfiles/.ruby.bash
source ~/dotfiles/.aliases.bash
source ~/dotfiles/.keys.bash
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

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
[ -f ~/.gpg-agent-info ] && source ~/.gpg-agent-info
if [ "$SSH_AUTH_SOCK" != "$HOME/.gnupg/S.gpg-agent.ssh" ]; then
  eval $( gpg-agent --daemon --enable-ssh-support >/dev/null 2>&1 )
  export GPG_TTY=$(tty)
fi
