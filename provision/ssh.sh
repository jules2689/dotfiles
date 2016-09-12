#!/bin/bash

if [[ ! -a ~/.ssh/id_rsa ]]; then
  # Generate SSH Keys
  mkdir -p ~/.ssh
  ssh-keygen -f ~/.ssh/id_rsa -t rsa -N '' -b 4096 -C "julian@jnadeau.ca"
  echo "Copying public key to keyboard, please add to Github"
  pbcopy < ~/.ssh/id_rsa.pub
fi
