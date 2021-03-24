#!/bin/bash

for k in {6..12..2}; do
 cd FE$k
  cp ../statistics.R ./
  tail -n 1 -q Stats{1..100} | awk '{print $1}' > full.dat
  Rscript statistics.R 
 cd ..
done

