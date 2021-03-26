source ~/dotfiles/.github.bash
source ~/dotfiles/.ruby.bash
source ~/dotfiles/.aliases.bash
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# Ruby
source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

export JAVA_HOME=$(/usr/libexec/java_home)
export ANDROID_HOME="/usr/local/opt/android-sdk"
export GOPATH="$HOME"
export EDITOR="vi"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_BUNDLE_BREW_SKIP=1
export GITHUB_PROFILE_BOOTSTRAP=1
export GITHUB_NO_AUTO_BOOTSTRAP=1

export PATH="/Applications/Postgres.app/Contents/MacOS/bin:$PATH"
export PATH="/user/local:$PATH"
export PATH="/usr/local/git/bin:$PATH"
export PATH="~/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$PATH:$GOPATH/bin"
export PATH="$HOME/dotfiles/scripts/:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:/usr/local/opt/mysql@5.7/bin"
export PATH="$(brew --prefix qt)/bin:$PATH"

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
  eval $( gpg-agent --daemon --options "$HOME/.gnupg/gpg-agent.conf" --enable-ssh-support >/dev/null 2>&1 )
  export GPG_TTY=$(tty)
fi

[ -f ~/src/github.com/jules2689/d2/exe/d2.sh ] && source ~/src/github.com/jules2689/d2/exe/d2.sh
export PATH="$PATH:/Users/juliannadeau/src/github.com/github/gh-helper-cli/exe"

docker_compose() {
  if [[ -f ".devcontainer/docker-compose.yml" ]] && [[ ! -f "docker-compose.yml" ]]; then
    export COMPOSE_FILE=".devcontainer/docker-compose.yml"
  else
    unset COMPOSE_FILE
  fi
}
trap 'docker_compose' DEBUG
if [ -e /Users/juliannadeau/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/juliannadeau/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

initenv() {
  which rbenv && eval "$(rbenv init -)"
  which nodenv && eval "$(nodenv init -)"
}
