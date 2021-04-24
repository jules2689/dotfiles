source ~/dotfiles/.github.zsh

# SSH Identity
eval "$(ssh-agent -s)" > /dev/null 2>&1
ssh-add ~/.ssh/id_rsa > /dev/null 2>&1
ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1

# GPG
[ -f ~/.gpg-agent-info ] && source ~/.gpg-agent-info
if [ "$SSH_AUTH_SOCK" != "$HOME/.gnupg/S.gpg-agent.ssh" ]; then
  eval $( gpg-agent --daemon --options "$HOME/.gnupg/gpg-agent.conf" --enable-ssh-support >/dev/null 2>&1 )
  export GPG_TTY=$(tty)
fi

# Own helper
[ -f ~/src/github.com/jules2689/d2/exe/d2.sh ] && source ~/src/github.com/jules2689/d2/exe/d2.sh

# Different Language Enviuronments
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init -)" > /dev/null 2>&1
fi
if command -v nodenv 1>/dev/null 2>&1; then
  eval "$(nodenv init -)" > /dev/null 2>&1
fi
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)" > /dev/null 2>&1
fi
