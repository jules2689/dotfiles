#NGrok
alias tunnel='function _tunnel(){ /Users/juliannadeau/ngrok/bin/ngrok -subdomain="$1" -config=/Users/juliannadeau/ngrok/bin/config.txt "$2"; };_tunnel'

#Code Directories
alias cdg="cd ~/Development"
alias cdgs="cd ~/Development/shopify"
alias cdv="cd ~/Development/shopify/rails/vagrant"
alias dc=cd
alias bk="cd ../../../"

#Mac Stuff
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

#Mysql Aliases
alias mysqlstart='/usr/local/bin/mysql.server start'
alias mysqlstop='/usr/local/bin/mysql.server stop'
alias startmysql='/usr/local/bin/mysql.server start'
alias stopmysql='/usr/local/bin/mysql.server stop'

#Postgres Aliases
alias postgresstart='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start -w'
alias postgrestart=postgresstart
alias startpostgres=postgresstart

alias postgresstop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias postgrestop=postgresstop
alias stoppostgres=postgresstop
alias stopostgres=postgresstop

alias web-images='function _webimages(){ echo "Compressing $1 files"; find *.$1 | xargs -I {} -n 1 convert {} -quality 75 -resize 800x {}; };_webimages'
