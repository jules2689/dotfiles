if [ ! $(gem list -i rubocop) ]; then
  gem install rubocop
fi

export PATH="$(which rubocop):$PATH"
