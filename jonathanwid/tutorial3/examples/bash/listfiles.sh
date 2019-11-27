#!/bin/bash
# listfiles.sh
# run with: ./listfiles.sh
#
# Print the argument values
echo “Listing files in /etc”
for somefile in /etc/*; do
    echo "This is the file $somefile, with type:";
    # the file command tells you the type of a file.
    file $somefile
done
