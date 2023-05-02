#!/bin/bash
#this script converts all fields in gender, $5, column to m, f, or u
if [[ $# != 1 ]]; then
    >&2 printf "\nUsage: filename\n"
    exit 1
fi

#male to m
sed -i 's/[Mm]ale/m/g' $1
#female to f
sed -i 's/[Ff]emale/f/g' $1
#sometimes it comes out as fem? fem to f
sed -i 's/fem/f/g' $1
#0 to m
sed -i 's/,0/,m/g' $1
#1 to f
sed -i 's/,1/,f/g' $1
sed -i 's/,,[,]/,//g' $1

#if not m or f, replace with u
gawk -i inplace 'BEGIN { FS="," } { if (($5 !~ /m/) || ($5 !~ /f/)) { string=$5; sub($string, "u", $12) } } {print}' $1

exit 0
