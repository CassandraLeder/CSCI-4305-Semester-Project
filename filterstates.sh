#!/bin/bash
#this script runs an awk command that finds and removes any fields that are "not a state" ie has a length greater than 2. I'll try to add in a regex that checks the states field for two characters,

if [[ $# != 1 ]]; then 
    >&2 printf "\nUsage: filename\n"
    exit 1
fi

awk 'BEGIN { FS="," }
{
    #you could hardcode in the states, but thats kindof excessive, yknow. 
    if (length($12) > 2) {
        system("cut ", FILENAME, " -d, -f12")
    }
}' $1

# if exceptions.csv is empty, then delete it
[ -s exceptions.csv ] || rm exceptions.csv
