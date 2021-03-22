#!/bin/bash
for k in {6..12..2}; do
N=10
(
for j in {1..100}; do
   ((i=i%N)); ((i++==0)) && wait
	echo FE_$j
	{ time Rscript --vanilla Non_Interacting.R 5000000 $k $j; }&
done
wait
)
done

for k in {6..12..2}; do
 cd FE$k 
 tail -n +2 -q Z{1..100}| awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}' > Z
 tail -n +2 -q Y{1..100}| awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}' > Y
 tail -n +2 -q X{1..100}| awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}' > X
 cd ..
done

bash run_graph_parallel.sh
