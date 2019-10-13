#!/bin/bash
# testfor.sh
# run with: ./testfor.sh arg1 arg2 arg3 ...
#
# Print the argument values
echo "Using lists of elements"
index=1          # Reset argument counter
for arg in "$@"; do
    echo "Arg #$index = $arg"
    let "index+=1"
  done             # $@ sees arguments as separate words.

echo "Using C syntax for the condition"
for ((i=1 ; i <= $# ; i++ )); do
    echo "Argument $i is ${!i}";
done

