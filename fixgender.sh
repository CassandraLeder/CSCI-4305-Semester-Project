#!/bin/bash

filename=$1

awk 'BEGIN {FS=","}

{
        if ($5 ~ /gender/) {
                #ignore case
         }

        #1 should be f
        else if ($5 ~ /1/) {
                sed 's/1/f/' $filename
         }

        #0 should be m
        else if ($5 ~ /0/) {
                sed 's/\b0\b/m/' $filename
        }

        #male should be m
        else if ($5 ~ /[Mm]ale/) {
                sed 's/male/m/' $filename
        }

        #female should be f
        else if ($5 ~ /[Ff]emale/) {
                sed 's/female/f' $filename
        }

        else {
                #sed 's/[a-zA-z]/u/' $filename
        }
}' $1
