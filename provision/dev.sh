#!/bin/bash

if [[ ! -d /opt/dev ]]; then
  eval "$(curl -sS https://dev.shopify.io/up)"
fi
