export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

rbenv install 2.3.0 -s
rbenv global 2.3.0

if [ ! $(gem list -i rubocop) ]; then
  gem install rubocop
fi

export PATH="$(which rubocop):$PATH"
