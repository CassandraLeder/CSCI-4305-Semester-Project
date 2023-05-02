#!/bin/bash
#this script runs an awk command that finds and removes any fields that are "not a state" ie not in state text file

if [[ $# != 1 ]]; then 
    >&2 printf "\nUsage: filename\n"
    exit 1
fi

#if not in states list, add it to exceptions
awk 'BEGIN { FS="," } { print $12 }' $1 | grep "$(cat states.txt)" >> exceptions.csv

#remove all lines with NAs
sed -i '/,NA,/d' $1

#remove lines not in states list
sed -i '/[^]]$(cat states.txt)/d' $1

# given file exists
if test -f exceptions.csv; then
    # if it is empty, then delete it
    [ -s exceptions.csv ] || rm exceptions.csv
fi

exit 0
