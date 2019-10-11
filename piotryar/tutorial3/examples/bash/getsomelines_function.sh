#!/bin/bash

# Function DEFINITION:
# Function that takes in input a filename and a number of lines
# outputs a message about the printed lines
#

# function NAME
printlinesoffile()
{ # function BODY
  # the first parameter is a filename
  FILENAME=$1
  # the second parameter is a number of lines
  NUMLINES=$2

  # variable with side effect: the result is stored in a global variable
  # be CAREFUL when to extract the value outside the function!
  # It changes at every function call!
  RESULT=$(cat $FILENAME | head -$NUMLINES)

  #Print out the lines
  echo "First $NUMLINES line(s) of $FILENAME:"
  echo "$RESULT"

} # end of function BODY

# put the first two lines of /proc/cpuinfo in CPUINFO using a function CALL
printlinesoffile /proc/cpuinfo 2
CPUINFO=$RESULT

# put the first four lines of /proc/meminfo in MEMINFO
printlinesoffile /proc/meminfo 4
MEMINFO=$RESULT

# put the first line of /etc/hostname in HOST
printlinesoffile /etc/hostname 1 
HOST=$RESULT

# See what happens with the side effect:
#echo "current value of RESULT is $RESULT" 
#echo "current value of CPUINFO is $CPUINFO" 
#echo "current value of MEMINFO is $MEMINFO" 
#echo "current value of HOST is $HOST" 

