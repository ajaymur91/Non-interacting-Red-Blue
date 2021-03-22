# Non-interacting-Red-Blue
# Saving data
echo FE{2..12..2}/Stats | xargs -n 1 tail -n 1 $1 > FE_full.txt

# Prep for graph appoach after Z integral calcs
# tail -n +2 -q Z{1..20}| awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}' > Z
# tail -n +2 -q Y{1..20}| awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}' > Y
# tail -n +2 -q X{1..20}| awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}' > X
