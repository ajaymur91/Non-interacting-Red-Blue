#!/bin/bash
for k in {2..12..2}; do
N=10
(
for j in {1..20}; do
   ((i=i%N)); ((i++==0)) && wait
	echo FE_$j
	{ time Rscript --vanilla Non_Interacting.R 5000000 $k $j; }&
done
wait
)
done
