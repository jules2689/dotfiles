function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
}

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
WHITE="\[\033[0;37m\]"

PS1="$RED\w$YELLOW\$(parse_git_branch)$WHITE ➜ "

alias gl='git log --graph --pretty=format:'\''%Cred%h%Creset %Cblue%an:%Creset %s - %C(yellow)%d%Creset %Cgreen(%cr)%Creset'\'' --abbrev-commit --date=relative'
alias sub="git submodule update --init --recursive"
alias gcp="git cherry-pick"
alias gc="git checkout"


if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi
