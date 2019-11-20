#!/bin/bash

###############################################################################
# 
# musicstats.sh - MNXB01-2019 Homework
#
# Author: Florido Paganelli florido.paganelli@hep.lu.se
#
# Description: this script downloads the c64 SIDTUNE database
#              and calculates tunes stats for a specificset of artists
#              provided by the user as a command line parameter.
#              It takes in input artist names in the format
#              LastName_Firstname
#              It creates a stats folder inside the folder where the
#              script is called and creates the following files:
#               - STIL-recordentries.txt: contains only paths to files.
#               - stats.csv: Contains the number of songs per artist.
#               For each artist it creates:
#                  - artistname-entries.txt: a subset of paths
#                                with the artist-only work
#                  - artistname-songs.txt: a list of filenames of
#                                    the songs the author created
#
# Example:
#        ./musicstats.sh Hubbard_Rob Follin_Tim Gray_Matt Tel_Jeroen
#
########################################################################
# This version of the script is pseudocode that the student
# should complete for homework-tutorial-3
########################################################################

###### Libraries provided by Florido. DO NOT TOUCH THE CODE BELOW ######

# this function prints an error with the information on how to run this
# script.
usage(){
	echo "----"
	echo -e "  Wrong syntax. To call this script please use"
	echo -e "   $0 '<artistlastname>_<artistname>' ['<artistlastname>_<artistname>' ...]"
	echo -e "  Example:"
	echo -e "   $0 'Hubbard_Rob'"
	echo "----"
}

####### CODE START #####################################################


# This variable contains the artist names passed as arguments. 
# Leave untouched. 
ARTISTNAMES=$@


### E1 (3 points) - Using an if, check that the variable $ARTISTNAMES
# is not empty and exit with error code 1.
# If empty, it means there is no artist name as first argument of the 
# script. 
# Print an explanatory error message to inform the user of the error.
# Use the predefined function usage() defined at lines 23-30 of 
# this file to give the user information how to pass the parameters.
# DO NOT MODIFY THE usage() FUNCTION BODY.

if [ -z "$ARTISTNAMES" ]; then
	echo "$(usage)"
else
	echo " Working on your artists!" 

fi

########################################################################
### E2 (3 points) Download the STIL.txt db
# Test if the STIL.txt file exists. If it doesn't exist, write the code 
# to download it using the wget command. 
# exit with error if the download fails.
# if the file already exists, do not download it and continue the
# execution.
# Hint: use the -e condition and the predefined variable $?

# E2.1 (2 points) if the STIL.txt file does not exist, download the file
if [ ! -e STIL.txt ]; then
	echo "You don't own this file, let's download it!"
	wget https://hvsc.de/download/C64Music/DOCUMENTS/STIL.txt
# E2.2 (1 point ) If the wget command fails, exit with error.
 if ! wget https://www.w3.org/TR/PNG/iso_8859-1.txt   ; then
	echo "The download failed"
	exit 1
fi
# otherwise (if the file exists) do not download anything
else 
	echo "STIL database found, will not download again."
fi

### E2 END #############################################################
########################################################################
### E3 (4 points) - Prepare the stats folder 
# The temporary folder should be called 'stats' and its name is stored in
# the STATSDIR variable.
# E3.1 (1 point) Define and instantiate the STATSDIR variable with
#string 'stats'

STATSDIR=stats

# E3.2 (2 points) Use an if to test if the 'stats' folder exists in the
# folder where the script is being executed.
# if it does, delete it.
# Always print out information to the user about what is happening.

if [ -d $PWD/stats ]; then
rm -r stats
echo "Directory stats found, removing old one"
fi

# E3.3 (1 point ) Create a new folder taking the name from the 
# variable $STATSDIR
echo "Creating new stats directory $STATSDIR"
mkdir ${STATSDIR}

### E3 END #############################################################

#### DO NOT TOUCH THE FOLLOWING  LINES OF CODE #########################

# If something wrong happened with the directory creation or there is
# no stats directory this code will exit the script.
if [[ ( $? != 0 ) || (! -e $STATSDIR) ]]; then
   echo "Directory creation failed or stats directory missing. Please check your code."
   echo "The script cannot continue. Exiting..."
   exit 1
fi

# If the above folder is created correctly,
# the next line will create a file inside the folder called stats.csv
# This file will contain information extracted from the STIL.txt database.
# DO NOT TOUCH THE FOLLOWING 2 LINES.
echo "Creating header for ${STATSDIR}/stats.csv data file"
echo "\"ARTISTNAME\",\"NUMSONGS\"" > ${STATSDIR}/stats.csv

#### END OF UNTOUCHABLE CODE ###########################################

########################################################################
########################################################################
### E4 (2 points) select only the lines in the STIL.txt file that start 
# with a slash symbol  '/' and save the result to a file called
# STIL-recordentries.txt in the stats folder.
# 
# To perform this task, use the egrep command and the ^ symbol, that 
#stands for "a line that starts with"
# for example "^a" selects all the lines that start with 'a'.
# egrep examples: https://www.computerhope.com/unix/uegrep.htm
# save the extracted lines to a file called ${STATSDIR}/STIL-recordentries.txt
# by redirecting the output of egrep with the > operator


echo "Saving all the record entries from the STIL file to a new file"
egrep '^/' STIL.txt > ${STATSDIR}/STIL-recordentries.txt

### E4 END #############################################################
########################################################################
### E5 (14 points)  - use a for to cycle the artist names contained in the
# $ARTISTNAMES variable.
# 
# E5.1 (1 point) use the proper variables inside the for condition and 
# body

for ARTIST_NAME in "$@"
do

echo "Looking for ${ARTIST_NAME} songs!"

egrep ${ARTIST_NAME} "${STATSDIR}"/STIL-recordentries.txt > "${STATSDIR}"/"${ARTIST_NAME}"-entries.txt

awk -F "/" '{print $NF}' "${STATSDIR}"/"${ARTIST_NAME}"-entries.txt > "${STATSDIR}"/"${ARTIST_NAME}"-songs.txt

sed -i '/^\r$/d' "${STATSDIR}"/"${ARTIST_NAME}"-songs.txt


NUMSONGS=$(wc -l "${STATSDIR}"/"${ARTIST_NAME}"-songs.txt | cut -f1 -d ' ') 

echo "Number of songs for artist ${ARTIST_NAME} is $NUMSONGS, storing in ${STATSDIR}/stats.csv" 

echo "\"${ARTIST_NAME}\",\"${NUMSONGS}\"" >> "${STATSDIR}"/stats.csv
done

########################################################################
# E6 (3 points) Calculate artist with most songs.
# To do this we will use the ${STATSDIR}/stats.csv file and order
# it  by number of songs.
# use the sort command to order the lines in the file and
# the tail command to extract the last line of the ordered file.
# If one or more artists have the same number of songs, the one
# that is in the last line will be selected as a winner.
# Store the line in the variable TOPSONGARTIST below.
# On the use of sort:
# https://www.geeksforgeeks.org/sort-command-linuxunix-examples/
# useful options: -h -k

TOPSONGARTIST=$(sort -h -k 2n "${STATSDIR}"/stats.csv  | tail -n 1)


 

### E6 END #############################################################

echo "The artist with most songs is:"
echo $TOPSONGARTIST

