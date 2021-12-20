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

#####
# Oh My ZSH
#####

export ZSH="/Users/juliannadeau/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="af-magic"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='code'
else
  export EDITOR='mvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
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
