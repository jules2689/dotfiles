#!/bin/bash

mycron=""

echo "*/5 * * * *  /bin/bash \"/Users/juliannadeau/Google Drive/WriteApp/Mobile Infrastructure/commit.sh\" >/tmp/stdout.log 2>/tmp/stdout.log" >> mycron

crontab mycron # Install crontab
rm mycron
