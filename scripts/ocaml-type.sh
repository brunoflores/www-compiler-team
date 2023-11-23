#!/bin/bash

# Read stdin.
in=$(cat)

# We need to escape HTML tags inside <pre> blocks.
# https://stackoverflow.com/questions/12873682/short-way-to-escape-html-in-bash
out=$(echo -n "${in};;" |
  ocaml -noprompt |
  tail -n 2 |
  sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g' |
  tr '\n' ' ')

# Print result inside a OCaml comment.
printf "(*%s*)" "$out"
