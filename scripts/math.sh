#!/bin/bash

echo "\documentclass[preview=true]{standalone}
\usepackage{amsmath}
\begin{document}" > tmp.tex
cat - >> tmp.tex
echo "\end{document}" >> tmp.tex

latex tmp.tex > latex.log
# See https://dvisvgm.de/Manpage/
dvisvgm --exact --font-format=woff --bbox=10pt --scale=1.5 tmp.dvi > /dev/null
cat tmp.svg
