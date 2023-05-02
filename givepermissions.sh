#!/bin/bash
#For this project, I used Github to work on two systems. Very helpful, however, everytime it pulls from origin, I lose permissions >:(

if [[ $# < 1 ]]; then
    printf "\nUsage: however many files to give execute permissions\n"
    exit 1
fi

chmod u+x $1 $2 $3 $4 $5 $6 $7 $8 $9

exit 0
