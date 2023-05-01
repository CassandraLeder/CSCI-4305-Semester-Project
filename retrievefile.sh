#!/bin/bash
#this script downloads a specified file from an ssh server
#ACCEPTS THE FOLLOWING ARGUMENTS: $1: server-name, $2: user-id, and $3: full path to file

passcode="00f00foof"

if [[ $# != 3 ]]; then
	>&2 printf '\nCorrect usage is $1: server-name, $2: user-id, $3: full path to file\n'
    exit 1
else 
    if scp $2@$1:$3 ./; then

        #if me, enter my passcode. DO NOT STEAL!
        if [[ $1 == "cleder" ]]; then
                ${passcode}
        fi

        printf "\nFile retrieval succeeded\n"
        exit 0
    else
        >&2 printf "\nFailure to retrieve file\n"
        exit 1
    fi
fi
