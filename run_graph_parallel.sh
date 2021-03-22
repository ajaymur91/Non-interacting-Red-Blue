#!/bin/bash
N=12
(
for j in {2..10..2}; do
   ((i=i%N)); ((i++==0)) && wait
	{ echo FE$j; time Rscript --vanilla Graph_NI.R $j 1 ;} &
done
)
