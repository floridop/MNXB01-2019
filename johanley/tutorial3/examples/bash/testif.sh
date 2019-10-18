#!/bin/bash
# testif.sh
# run with: ./testif.sh arg1 arg2 arg3
#
# test that at least two arguments are passed to the script
if  [[ $# -le 2 ]];  then
    echo "Not enough arguments. Must be at least 3!";
    exit 1;
else
    echo "More than 2 arguments. Good!";
    exit 0;
fi
