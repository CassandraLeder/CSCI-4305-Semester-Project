#!/bin/bash
#Cassandra Leder
#Semester Project

#This script finds and removes all dollar signs from the 6th column of the file sent to the script

# if number of args wrong
if [[ $# != 1 ]]; then
    >&2 printf "\nUsage: filename\n"
    exit 1
fi

# if file does not exist
if test -f "$1"; then
    :
else
    >&2 printf "\nMust be a file\n"
    exit 1                
fi    

gawk -i inplace 'BEGIN { FS=OFS="," }
{
        #globally substitute all $s with empty only in column 6
        sub(/\$/, "", $6)
}' $1
