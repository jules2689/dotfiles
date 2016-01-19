#!/bin/bash

# Generate SSH Keys
mkdir -p ~/.ssh
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N '' -b 4096 -C "julian@jndeau.ca"
echo "Copying public key to keyboard, please add to Github"
pbcopy < ~/.ssh/id_rsa.pub
