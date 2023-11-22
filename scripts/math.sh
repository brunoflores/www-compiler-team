#!/bin/bash

cat - > tmp.tex
latex tmp.tex > latex.log
dvisvgm tmp.dvi > /dev/null
cat tmp.svg
