#!/bin/bash
#this script downloads a specified file from an ssh server
#ACCEPTS THE FOLLOWING ARGUMENTS: $1: server-name, $2: user-id, and $3: full path to file

if [[ $# != 3 ]]; then
	>&2 printf '\nCorrect usage is $1: server-name, $2: user-id, $3: full path to file\n'
	exit 1
else
	scp $2@$1:$3 ./
	exit 0
fi
