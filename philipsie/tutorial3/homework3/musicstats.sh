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

###### Libraries provided by Florido. END OF UNTOUCHABLE CODE ##########

###### EDIT THE CODE BELOW, follow instructions ########################

#
# Student: PHILIP_SIEMUND
#

### E0 (2 points) fill the blanks
# inspect the weblink
#    https://hvsc.de/download/C64Music/DOCUMENTS/STIL.txt
# and try to guess if it is a known format.
# understand what kind of data structure the data contained in the
# file has. Some additional info:
# - .sid is a file format for c64 music files. 
# - the STIL collection is physically organized in folders and files,
#   that is why one can see path-like entries in the file, such as
#   /DEMOS/A-F/Amiga_Mix.sid
#
# (1 point) What is the encoding of the STIL.txt database file?
# Discover it by downloading it and using the file command.
#  file STIL.txt
# Paste the output of the file command below.
# The encoding is ISO-8859 text, with CRLF line terminators.
#
# (1 point) Which of the following statement do you think it is true
# about the file format in order to complete the sentence below
# Only one of the three choices is true. 
# Put an X between the [ ] of the one you think is true.
#
# Every record (that is, information about a .sid file) 
# of this database ...
# a) [ ] ... starts and ends with a sequence of symbols # (hash)
# b) [ ] ... starts with a path /something/.../something.sid entry
#       and ends with a blank line
# c) [X] ... starts with a path /something/.../something.sid entry 
#       and ends with an ARTIST: or COMMENT entry
#
# hint: find counter examples that contradict 
#       each of the above statements (if any).


####### CODE START #####################################################


ARTISTNAMES=$@

### E1 (3 points)

if [[ -z "$ARTISTNAMES" ]]; then
   usage
   exit 1
fi

### E2 (3 points) 

# E2.1 (2 points) 

URL='https://hvsc.de/download/C64Music/DOCUMENTS/STIL.txt'
if [[ -e STIL.txt ]]; then
	echo 'STIL.txt file found, will not download again.'
else
	echo 'Downloading STIL.txt file.'
	wget "$URL"
fi
# E2.2 (1 point ) 

if [[ $? -ne 0 ]]; then
	echo 'wget error, check your script.'
	exit 1
fi

### E3 (4 points) 

# E3.1 (1 point) 

STATSDIR='stats'

# E3.2 (2 points) 

if [[ -e "$STATSDIR" ]]; then
	rm -rf "$STATSDIR"
	echo "Deleting old $STATSDIR directory."
fi
	
# E3.3 (1 point ) 

mkdir "$STATSDIR"
echo "Creating new $STATSDIR directory."

#### DO NOT TOUCH THE FOLLOWING LINES OF CODE ####

if [[ ( $? != 0 ) || (! -e $STATSDIR) ]]; then
   echo "Directory creation failed or stats directory missing. Please check your code."
   echo "The script cannot continue. Exiting..."
   exit 1
fi

echo "Creating header for ${STATSDIR}/stats.csv data file."
echo "\"ARTISTNAME\",\"NUMSONGS\"" > ${STATSDIR}/stats.csv

#### END OF UNTOUCHABLE CODE ####

### E4 (2 points)

egrep -n "^/" STIL.txt > ${STATSDIR}/STIL-recordentries.txt

### E5 (14 points)

for artistname do
	egrep "$artistname" ${STATSDIR}/STIL-recordentries.txt > ${STATSDIR}/${artistname}-entries.txt

	awk -F/ '{print $NF}' ${STATSDIR}/${artistname}-entries.txt > ${STATSDIR}/${artistname}-songs.txt

	sed -i '/^[[:space:]]*$/d' ${STATSDIR}/${artistname}-songs.txt 

	NUMSONGS=$(wc -l ${STATSDIR}/${artistname}-songs.txt | awk '{print $1}') #used awk instead of cut

	echo "Number of songs for $artistname is $NUMSONGS, storing in ${STATSDIR}/stats.csv."

	echo "\"$artistname\",\"$NUMSONGS\"" >> ${STATSDIR}/stats.csv
done

### E6 (3 points)


TOPSONGARTIST=$(sort -k2 ${STATSDIR}/stats.csv | tail -n1)

echo "The artist with most songs is: $TOPSONGARTIST"

# Max points: 31
