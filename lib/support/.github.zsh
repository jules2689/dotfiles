function parse_git_dirty {
  if [ -d .git ]; then
  	[[ $(git status --porcelain) != "" ]] && echo "*"
  fi
}

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
}

RED="%F{red}"
YELLOW="%F{33}"
GREEN="%F{32}"
WHITE="%F{37}"

PS1="%F{red}\$(pwd)%1 %F{yellow}\$(parse_git_branch)%f ➜ "

zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

autoload -Uz compinit && compinit