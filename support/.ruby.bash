source /opt/dev/dev.sh

chruby 2.3.1

if [ ! $(gem list -i rubocop) ]; then
  gem install rubocop
fi

export PATH="$(which rubocop):$PATH"
