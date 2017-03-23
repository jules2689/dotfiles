#!/bin/bash
set -eo pipefail

echo "Setting some default system settings"
DevToolsSecurity -enable

echo "Restoring app settings"
echo "This assumes that you are signed into icloud"
mackup restore --force
