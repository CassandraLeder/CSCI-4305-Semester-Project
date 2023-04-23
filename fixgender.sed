#!/bin/sed

#change 1 to f
5 c\
#1 to f
1\f 
#0 to m
0\m
#male to m
male\m

#female to f
female\f

#else is u
\u
