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
# Student: Jasmain HUYNH
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
# The encoding is ISO 8859
#
# (1 point) Which of the following statement do you think it is true
# about the file format in order to complete the sentence below
# Only one of the three choices is true. 
# Put an X between the [ ] of the one you think is true.
#
# Every record (that is, information about a .sid file) 
# of this database ...
# a) [ ] ... starts and ends with a sequence of symbols # (hash)-> no sometimes it ends with an ARTIST or COMMENT entry e.g  ARTIST: Johann Sebastian Bach and of course a blank line after
# b) [X] ... starts with a path /something/.../something.sid entry
#       and ends with a blank line
# c) [ ] ... starts with a path /something/.../something.sid entry 
#       and ends with an ARTIST: or COMMENT entry ->    NAME: In the South African sector, plan to divest, here it ends with NAME entry and of course a blank line after
#
# hint: find counter examples that contradict 
#       each of the above statements (if any).


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

if [[ $# -le 0 ]]; then 
echo "You forgot to include the artist last name and name"
usage;
exit 1
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
FILE=~/MNXB01-2019/jasmainhuy/tutorial3/homework3/code/samplefolder/STIL.txt
if [[ ! -e $FILE ]]; then
	echo "Files does not exist we will download it"
	WGET=$(wget https://hvsc.de/download/C64Music/DOCUMENTS/STIL.txt -P ~/MNXB01-2019/jasmainhuy/tutorial3/homework3/code/samplefolder)
   
   # E2.2 (1 point ) If the wget command fails, exit with error.
   if [[! $? -ne 0]]; then
   echo "ERROR"
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
# the string 'stats'
#YOUR_CODE_HERE
STATSDIR=stats


# E3.2 (2 points) Use an if to test if the 'stats' folder exists in the
# folder where the script is being executed.
# if it does, delete it.
# Always print out information to the user about what is happening.
#YOUR_CODE_HERE
if [[ -d $STATSDIR ]]; then
echo "Stats directory exist, we remove it 'stats' REMOVED"
RM=$(rm -r ~/MNXB01-2019/jasmainhuy/tutorial3/homework3/code/stats)

# E3.3 (1 point ) Create a new folder taking the name from the 
# variable $STATSDIR
CR=$(mkdir ~/MNXB01-2019/jasmainhuy/tutorial3/homework3/code/$STATSDIR)
else
CR=$(mkdir ~/MNXB01-2019/jasmainhuy/tutorial3/homework3/code/$STATSDIR)
fi
echo "Creating new stats directory $STATSDIR"


### E3 END #############################################################

#### DO NOT TOUCH THE FOLLOWING  LINES OF CODE #########################

# If something wrong happened with the directory creation or there is
# no stats directory this code will exit the script.


# If the above folder is created correctly,
# the next line will create a file inside the folder called stats.csv
# This file will contain information extracted from the STIL.txt database.
# DO NOT TOUCH THE FOLLOWING 2 LINES.
echo "Creating header for ${STATSDIR}/stats.csv data file"
echo "\"ARTISTNAME\",\"NUMSONGS\"" > ${STATSDIR}/stats.csv

#### END OF UNTOUCHABLE CODE ###########################################

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
# 20190929 UPDATE: Sorry this comment was missing when I uploaded the exercise:
#                  I would like to have the line numbers of each line 
#                  that matches the specified pattern. 
#                  Add the -n option to egrep.
#                  This is why in the example files 
#                  code/samplefolder/stats/STIL-recordentries.txt
#                  code/samplefolder/<artistname>-entries.txt
#                  there are numbers at the beginning of each line.
#                  
#                
#

EGRP=$(egrep -n '^/' ~/MNXB01-2019/jasmainhuy/tutorial3/homework3/code/samplefolder/STIL.txt>${STATSDIR}/STIL-recordentries.txt)
echo "Putting inside STILL-recordentries.txt, inside you have the line numbers of each line that matches the specified pattern '/'"


### E4 END #############################################################

########################################################################
### E5 (14 points)  - use a for to cycle the artist names contained in the
# $ARTISTNAMES variable.
# 
# E5.1 (1 point) use the proper variables inside the for condition and 
# body 
for ((i=1 ; i <= $# ; i++ )); do
echo "Artist number $i is ${!i}";
   
   #####################################################################
   ### E5.2 (2 points) Create a file containing only artist-specific 
   # record entries.
   # Use the grep command to select only the entries that
   # contain the requested artist from the ${STATSDIR}/STIL-recordentries.txt
   # file.
   # Write the output in a file inside the stats dir,
   # called stats/artistname-entries.txt
   # for example, if one of the artist is Follin_Tim, 
   # the file is stats/Follin_Tim-entries.txt
   #
EGRP_song=$(egrep -n "${!i}" ~/MNXB01-2019/jasmainhuy/tutorial3/homework3/code/stats/STIL-recordentries.txt>${STATSDIR}/${!i}-entries.txt)


   ### E5.2 END ########################################################

   #####################################################################
   ### E5.3 (3 points) Extract the artist song names and store them in a file
   # called ${STATSDIR}/${ARTISTNAME}-songs.txt
   # use the awk command , the / separator and the $NF special awk variable
   # to do that. Remember that the song name is the last element of the
   # line. Some hints here:
   # https://www.shellhacks.com/awk-print-column-change-field-separator-linux-bash/
AWK_namesong=$(awk -F "/" '{print $NF}' $STATSDIR/${!i}-entries.txt>${STATSDIR}/${!i}-songs.txt)   
echo "creation of a text file ${!i}-songs.txt, with all artist's song"
   
   ### E5.3 END ########################################################

   #####################################################################
   ### E5.4 (3 points) Remove blank lines from the ${STATSDIR}/${ARTISTNAME}-songs.txt
   # file
   # Use the sed command with the /d (delete pattern)functionality. 
   # sed uses regular expressions, a special way to express parts of strings.
   # The expression is enclosed within two or more slashes / / and the 
   # last slash is followed by some letter that represents a functionality.
   # The epressions have special characters that match the content of a file.
   # useful for this exercise are:
   #  ^  : the beginning of a line
   #  $  : the end of a line
   #  \r : a newline
   # Example:
   #    sed  '/\.sid\r$/d' STIL.txt
   # Will delete all lines ending in .sid[newline]
   # 
   # More info here:
   # http://fibrevillage.com/scripting/619-ways-to-remove-empty-lines-in-a-file-on-linux
   # remember that the blank lines may contain invisible characters such
   # such as the pattern \r (line feed) . 
   # Check the file with geany if you suspect so.
   # 
BL2=$(sed -i '/\#\r$/d' ${STATSDIR}/${!i}-songs.txt)
BL=$(sed -i '/^\r$/d' ${STATSDIR}/${!i}-songs.txt)
echo "deleting all blank line in ${!i}-song.txt"
   #
   ### E5.4 END ########################################################

   #####################################################################
   ### E5.5 (4 points) Count the number of songs of the musician, and store
   # the information in the variable NUMSONGS .
   # To do this one can count the number of lines in the 
   # ${STATSDIR}/${ARTISTNAME}-songs.txt using the wc command.
   # https://www.tecmint.com/wc-command-examples/
   # Use the cut command to take only the number in the output of wc.
   #
ARTISTNAME=${!i}
NUMSONGS=$(wc ~/MNXB01-2019/jasmainhuy/tutorial3/homework3/code/${STATSDIR}/${!i}-songs.txt | cut -d " " -f 2-3)
   ### E5.5 END ########################################################

   echo "Number of songs for artist $ARTISTNAME is $NUMSONGS, storing in ${STATSDIR}/stats.csv" 
   
   #####################################################################
   ### E5.6 (1 points) Store the name of the artist and the number of 
   # songs in a csv file called ${STATSDIR}/stats.csv. 
   # The name and the number must
   # be surrounded by double quotes, and separated by a comma ,
   # example:
   # "Hubbard_Rob","61"
   # use echo, escape (prevent bash to consider them part of the language
   # grammar) the quotes by prefixing them with \, 
   # and write the file using the >> operator. (append to file operator)
   # use the variable names $ARTISTNAME and $NUMSONGS!
   # You can see an example of the syntax at line 140.
   #
echo "Number of songs for artist $ARTISTNAME is $NUMSONGS, storing in ${STATSDIR}/stats.csv"
echo \ ${!i},$NUMSONGS>>${STATSDIR}/stats.csv
done   # End of for loop
### E5 END #############################################################	

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
#
TOPSONGARTIST=$(sort -t '"' -k 4 -n ${STATSDIR}/stats.csv>${STATSDIR}/stats.csv | tail -n 1)

### E6 END #############################################################

echo "The artist with most songs is:"
echo $TOPSONGARTIST

# Max points: 31
