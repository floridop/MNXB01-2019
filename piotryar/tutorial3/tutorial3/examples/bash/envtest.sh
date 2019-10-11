#!/bin/bash

# test if an environment variable is defined
if [ "x$MYENV1" == "x" ]; then
	echo "MYENV1 not defined in the environment or empty. Please run"
        echo 'export MYENV1="This is my first environment variable"'
fi

# create an environment variable
MYENV2="This is my second environment variable"

# write the content of the environment vars to screen
echo "Content of MYENV1: $MYENV1"
echo "Content of MYENV2: $MYENV2"

echo "Now check if MYENV2 content is still defined, with the command"
echo 'echo $MYENV2'
