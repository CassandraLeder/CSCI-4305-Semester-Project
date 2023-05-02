#!/bin/bash
#script creates the transaction report

touch tranasaction.rpt

printf "REPORT BY: Cassandra Leder  Tranasaction Count Report" >> tranasaction.rpt

states="./states.txt"

while read line; do
    echo "${line}"
done < "${file}"
