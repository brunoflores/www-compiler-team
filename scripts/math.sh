#!/bin/bash

in=$(echo $(</dev/stdin))

uq=$(echo $in | cksum | cut -f 1 -d ' ')

file=".scripts-cache/${uq}.svg"
if [ -f "$file" ]; then
  cat $file
  exit 0
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

\begin{document}" > .scripts-cache/${uq}.tex
echo "$in" >> .scripts-cache/${uq}.tex
echo "\end{document}" >> .scripts-cache/${uq}.tex

latex .scripts-cache/${uq}.tex > /dev/null
mv ${uq}.dvi ${uq}.log ${uq}.aux .scripts-cache/

# See https://dvisvgm.de/Manpage/
dvisvgm --no-styles --exact --font-format=woff --bbox=10pt --scale=1.5 .scripts-cache/${uq}.dvi
mv ${uq}.svg .scripts-cache/

cat .scripts-cache/${uq}.svg
