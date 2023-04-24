#!/bin/bash
#This program performs the command specified in the program then returns whether the command is successful

if [[ $# != 1 ]]; then
	printf "\nCorrect usage: command for testing\n"
	exit 1
$(1)

if [[ $? == 1 ]]; then
	return false
else
	return true
fi

exit 0
