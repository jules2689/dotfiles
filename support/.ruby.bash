source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

chruby ruby-2.3.1

if [ ! $(gem list -i rubocop) ]; then
  gem install rubocop
fi

export PATH="$(which rubocop):$PATH"
