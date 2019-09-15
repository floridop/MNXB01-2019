--------------------------------------------------------
# MNXB01-2019-homework-3
--------------------------------------------------------
### Author: Florido Paganelli florido.paganelli@hep.lu.se
###         Lund University
--------------------------------------------------------

## Overview 

In this exercise you will be asked to

1) Download a dataset from the internet and understand its format
2) Rework the content of such database using bash and selected
   bash commands and utilities , following the structure of 
   some pseudocode
3) Write out the results to screen or files in a specific format

## Goals

In this homework you will edit some bash pseudocode and implement
the requested functionalities.

I will ask you to automate the download and processing of a dataset of
computer music called STIL.txt.

This dataset is accessible at this URL:
  <https://hvsc.de/download/C64Music/DOCUMENTS/STIL.txt>
More information about the music collection can be found in the references.

This dataset contains information about some music files stored in
folders. Every entry of the database is in fact a path of the form
`/collection/subcollection/..../artist name/song filename.sid`
where .sid is a data format for c64 music.

Your task is to edit the script musicstats.sh so that it:
1. Downloads the STIL.txt database from the aforementioned URL. If the 
file has already been downloaded, the script should NOT redownload it.
2. Creates a folder called `stats` where it will store some information
taken from the STIL.txt file. The directory is removed and recreated
every time the script is run.
3. The information contained in `stats` is as follows:
   * a file called  `STIL-recordentries.txt` that contains only the file
     paths and their line numbers in the STIL.txt database without any 
     other information.
   * a file called stats.csv that will contain for each artist the number
     of songs written by the artist
   * for each artist, two scripts will be created:
     * artistname-entrier.txt - contains only the paths relative to an artist
     * artistname-songs.txt - contains only the song names of a given artist
4. The script must be able to create such contents based on a selection 
   of artist that the user can pass via command line. As an example 
   I created the expected output files for this script execution:
```shell
   ./musicstats.sh Hubbard_Rob Follin_Tim Gray_Matt Tel_Jeroen
```
The example generated files are in the `samplefolder` and the example 
output to screen of the script is in the `sampleoutputs` folder:
* output_files_creation.log  : the script downloads the database and creates the stats directory
* output_files_exist.log : the script does not need to download the STIL.txt file and deletes the stats directory.
case where database and script folder are not present

You can use the above sample data for comparison with your progress.

To compare files, you can use a tool called `meld` on the VM.
Another classic way of comparing files is to use the tool called `diff`.

## How to obtain the homework files

1. Create a work folder in your home.
```shell
   mkdir ~/work
   cd ~/work
```

2. Download the zip file:
```shell
   wget https://github.com/floridop/MNXB01-2019/archive/master.zip
```
   
3. Unpack the files with unzip
```shell
   unzip master.zip
```

4. copy the content of the following directory inside your work folder
```shell
   cp -r  MNXB01-2019-master/floridopag/tutorial3/homework3 .
```

5. Enter the `homework3` folder
```shell
   cd homework3
```

6. Rename musicstats.sh.pseudocode
```shell
   mv musicstats.sh.pseudocode musicstats.sh
```

7. Read and edit `musicstats.sh` with your favorite editor to carry on 
the homework.


## How to submit the homework

The homework must be submitted as a git pull request to this repository.
This task will be clearer after the git tutorial (Tutorial 5), and this 
README will be updated accordingly. 
