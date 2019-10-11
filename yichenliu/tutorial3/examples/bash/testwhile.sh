#!/bin/bash
# testwhile.sh
# run with: ./testwhile.sh
#
# Continue asking numbers until the user writes “end”
while [ "$var1" != "end" ]; do     # while test "$var1" != "end"
  echo "Input variable value (end to exit) "
  read var1                   # Not 'read $var1' (why?).
  echo "variable value = $var1"   # Need quotes because of "#" . . .
  # If input is 'end', echoes it here.
  # Does not test for termination condition until top of loop.
echo
done  
exit 0
