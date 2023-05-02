#!/bin/bash
#finds customer_ids and computes their purchase amounts, then uses the info to generate a .csv file

if [[ $# != 1 ]]; then
    >&2 printf "\nUsage: filename\n"
    exit 1
fi

awk 'BEGIN { FS="," } { printf "%s,%s,%s,%s,%s,%s\n", $1, $12, $13, $3, $4, $6}' $1 > temp.txt

awk 'BEGIN { FS=OFS="," } 
$1 == p1 { prev = prev OFS $NF; next }
{if (NR > 1) print prev; prev = $0; p1 = $1}
END {print prev}' temp.txt > temp1.txt

awk 'BEGIN {FS=OFS=","}
{$6 += $6+$7+$8+$9+$10; print $1 "," $2 "," $3 "," $4 "," $5 "," $6}' temp1.txt > temp.txt

cat temp.txt | sort -t, -n -k2,2 -k3,3 -k4,4 -k5,5 > temp1.txt

cat temp1.txt > summary.csv
rm temp.txt temp1.txt

exit 0
