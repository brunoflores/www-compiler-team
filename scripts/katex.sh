#!/bin/bash

in=$(echo $(</dev/stdin))

uq=$(echo $in | cksum | cut -f 1 -d ' ')

file=".scripts-cache/${uq}.katex"
if [ -f "$file" ]; then
  cat $file
  exit 0
fi

echo "$in" | node ./scripts/katex.js > $file
cat $file
