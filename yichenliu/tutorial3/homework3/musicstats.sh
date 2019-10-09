#!/bin/bash

###############################################################################
# 
# musicstats.sh - MNXB01-2019 Homework
#
# Author: Florido Paganelli florido.paganelli@hep.lu.se
#
# Description: this script downloads the c64 SIDTUNE database
#              and calculates tunes stats for a specific set of artists
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
# Student: Yichen Liu
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
# The encoding is __ISO-8859 text, with CRLF line terminators__
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

if [[ -z $ARTISTNAMES ]]; then
   usage
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
if [ ! -f STIL.txt ]; then
   echo 'STIL database not found. Downloading...'
   wget https://hvsc.de/download/C64Music/DOCUMENTS/STIL.txt
   
   # E2.2 (1 point ) If the wget command fails, exit with error.
   if ! wget -o /dev/null https://hvsc.de/download/C64Music/DOCUMENTS/STIL.txt; then
      echo 'Fail to download STIL.txt'
      exit 1
   
   fi
   # otherwise (if the file exists) do not download anything
   else echo "STIL database found, will not download again."
fi

### E2 END #############################################################

########################################################################
### E3 (4 points) - Prepare the stats folder 
# The temporary folder should be called 'stats' and its name is stored in
# the STATSDIR variable.
# E3.1 (1 point) Define and instantiate the STATSDIR variable with
# the string 'stats'
STATSDIR='stats'
#echo $STATSDIR
#echo -en '\n'


# E3.2 (2 points) Use an if to test if the 'stats' folder exists in the
# folder where the script is being executed.
# if it does, delete it.
# Always print out information to the user about what is happening.
echo "Checking if the 'stats' folder exits ... "
if [[ -e ./stats ]]; then
   echo " It does exist, we delete it. "
   rm -rf stats/
   echo -en '\n'
fi

# E3.3 (1 point ) Create a new folder taking the name from the 
# variable $STATSDIR
echo "Creating new stats directory $STATSDIR"
mkdir $STATSDIR

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
#echo 'Collecting music records and saving in' ${STATSDIR}/STIL-recordentries.txt
egrep -n ^/ STIL.txt > ${STATSDIR}/STIL-recordentries.txt
#echo -en '\n'
#
### E4 END #############################################################

########################################################################
### E5 (14 points)  - use a for to cycle the artist names contained in the
# $ARTISTNAMES variable.
# 
# E5.1 (1 point) use the proper variables inside the for condition and 
# body
for arg in "$@"; do
   
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
   #echo 'Collecting records from' $arg 'and storing them in' ${STATSDIR}/$arg-entries.txt
   grep $arg ${STATSDIR}/STIL-recordentries.txt > ${STATSDIR}/$arg-entries.txt
   #
   ### E5.2 END ########################################################

   #####################################################################
   ### E5.3 (3 points) Extract the artist song names and store them in a file
   # called ${STATSDIR}/${ARTISTNAME}-songs.txt
   # use the awk command , the / separator and the $NF special awk variable
   # to do that. Remember that the song name is the last element of the
   # line. Some hints here:
   # https://www.shellhacks.com/awk-print-column-change-field-separator-linux-bash/
   #
   #echo 'Collecting songs from '$arg' and storing them in' ${STATSDIR}/$arg-songs.txt
   awk -F "/" '{print $NF}' ${STATSDIR}/$arg-entries.txt > ${STATSDIR}/$arg-songs.txt
   #
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
   sed -i '/^$/d' ${STATSDIR}/${arg}-songs.txt 
   #awk NF ${STATSDIR}/${arg}-songs.txt > ${STATSDIR}/${arg}-songss.txt 
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
   NUMSONGS=$( wc -w < ${STATSDIR}/$arg-songs.txt )
   #
   ### E5.5 END ########################################################

   echo "Number of songs for artist $arg is $NUMSONGS, storing in ${STATSDIR}/stats.csv" 
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
   ARTISTNAME=$arg
   echo "\"$ARTISTNAME\",\"$NUMSONGS\"" >> ${STATSDIR}/stats.csv
   #
   ### E5.6 END ########################################################

done  # End of for loop
### E5 END #############################################################


TOPSONGARTIST=$( sort -k 2n ${STATSDIR}/stats.csv | tail -1)

echo "The artist with most songs is:"
echo $TOPSONGARTIST
