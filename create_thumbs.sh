#!/usr/bin/env bash

for i in $(find . -type f)
do
    convert -geometry 200x $i 200px/$i
done
