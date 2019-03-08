function parse_git_dirty {
  if [ -d .git ]; then
  	[[ $(git status --porcelain) != "" ]] && echo "*"
  fi
}

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
}

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
WHITE="\[\033[0;37m\]"

PS1="$RED\w$YELLOW\$(parse_git_branch)$WHITE ➜ "

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi
