#!/bin/bash

mycron=""

echo "*/5 * * * *  /bin/bash \"/Users/juliannadeau/Google Drive/WriteApp/Mobile Infrastructure/commit.sh\" >/tmp/stdout.log 2>/tmp/stdout.log" >> mycron
echo "0 22 * * * ruby /Users/juliannadeau/Development/personal/other/dotfiles/support/git_backup.rb \"/Users/juliannadeau/Dropbox/Backup/repo_list.json\"" >> mycron

crontab mycron # Install crontab
rm mycron
