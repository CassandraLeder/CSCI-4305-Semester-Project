#!/bin/gawk
#take a path and return the full file name
BEGIN { FS="/" }
{
    for(i = 1; i <= NF; i++)
        if ($i ~ /.csv.bz2/)
            filename = $i
}
END { print filename }
