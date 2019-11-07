#!/bin/bash

# definition of a function that gets meminfo
getmeminfo(){
MEMINFO=$(cat /proc/meminfo)
}

# call of the function, it will change the environment
getmeminfo

# write the content of MEMINFO to screen
echo "$MEMINFO"
