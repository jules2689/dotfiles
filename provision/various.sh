#!/bin/bash
set -eo pipefail

echo "Setting global github settings"
git config --global user.name "Julian Nadeau"
git config --global user.email "julian@jnadeau.ca"

echo "Setting some default system settings"
DevToolsSecurity -enable
