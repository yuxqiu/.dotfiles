#!/bin/bash

# https://stackoverflow.com/a/41199625
npm list --global --parseable --depth=0 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > npmlist.txt
