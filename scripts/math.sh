#!/bin/bash

cat - > me.tex
latex me.tex > latex.log
dvisvgm me.dvi > /dev/null
cat me.svg
