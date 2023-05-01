#!/bin/bash
#this script finds and removes $s from $6 purchase_amt

if [[ $# != 1 ]]; then
    >&2 printf "\nUsage: filename\n"
    exit 1
fi

gawk -i inplace 'BEGIN { FS="," } {gsub(/,\$/, ",", $6)}' $1

if [[ $? == 0 ]]; then
    printf "\n\$s removed from file\n"
    exit 0
else
    >&2 printf "\nscript failed\n"
    exit 1
fi

#just in case
exit 2
