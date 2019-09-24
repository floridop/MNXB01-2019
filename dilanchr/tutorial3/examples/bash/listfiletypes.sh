#!/bin/bash
# listfiletypes.sh
# run with: ./listfilestypes.sh <directory>
#
# Print the argument values

TARGETDIR=$1

# A typical use of IF: if no TARGETDIR defined, then x == x and the expression in brackets will
# be false, so the else branch will be executed and an error message will be shown.
if [ "x$TARGETDIR" == "x" ]; then
     TARGETDIR=~
     MESSAGE="No argument found. Listing filetypes for the home directory $TARGETDIR by default"
else
     MESSAGE="Scanning filetypes for the ${TARGETDIR} directory"
fi

echo "$MESSAGE"

# scans all files in $TARGETDIR
for somefile in ${TARGETDIR}/*; do
    echo "This is the file $somefile, with type:";
    # the file command tells you the type of a file.
    file $somefile
done
