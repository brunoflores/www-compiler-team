#!/bin/bash

fresh=false
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --fresh) fresh=true ;;
    *) echo "Unknown parameter passed: $1"; exit 1 ;;
  esac
  shift
done

# Read stdin.
in=$(cat)

uq=$(echo $in | cksum | cut -f 1 -d ' ')

if [ "$fresh" = false ]; then
  file=".scripts-cache/${uq}.svg"
  if [ -f "$file" ]; then
    cat $file
    exit 0
  fi
fi

echo "\documentclass[preview=true]{standalone}
\usepackage{amsmath}
\usepackage{amsthm}
\usepackage{qtree}
\usepackage{semantic}
\usepackage{amssymb}

\usepackage[dvipsnames]{xcolor}
\newcommand{\graybox}[1]{
  \colorbox{lightgray}{#1}
}

\newtheorem*{theorem}{Theorem}

\usepackage[T1]{fontenc}
\usepackage{isabelle,isabellesym}
\usepackage{mathpartir}

\isabellestyle{it}

\newcommand{\snip}[4]
  {\expandafter\newcommand\csname #1\endcsname{#4}}

\input{snippets}

\begin{document}" > .scripts-cache/${uq}.tex
echo "$in" >> .scripts-cache/${uq}.tex
echo "\end{document}" >> .scripts-cache/${uq}.tex

latex .scripts-cache/${uq}.tex > .scripts-cache/${uq}.log
mv ${uq}.dvi ${uq}.log ${uq}.aux .scripts-cache/

# See https://dvisvgm.de/Manpage/
dvisvgm --no-styles --exact --font-format=woff --bbox=10pt --scale=1.5 .scripts-cache/${uq}.dvi
mv ${uq}.svg .scripts-cache/

cat .scripts-cache/${uq}.svg
