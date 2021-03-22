#!/bin/bash
N=12
(
for j in {6..10..2}; do
   ((i=i%N)); ((i++==0)) && wait
	{ echo FE$j; time Rscript --vanilla Graph_NI.R $j 10 ;} &
done
)
