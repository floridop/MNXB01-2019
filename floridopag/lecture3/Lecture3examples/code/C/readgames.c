/*
 * readgames.c
 * 
 * Copyleft 2016 Florido Paganelli<florido.paganelli@hep.lu.se>
 * 
 */

// standard library to allocate memory
#include <stdlib.h>
// input/output library
#include <stdio.h>

int main(int argc, char **argv)
{
    // a sequence of chars will contain the file
	char *filecontents;
    // C doesn't automatically know the size of a file
    long input_file_size;
    // opening the file nintendowiigames.xml for reading 
    FILE * input_file = fopen("../../data/nintendowiigames.xml", "rb");
    // Calculating the size of the file:
    // reach the end of the file
    fseek(input_file, 0, SEEK_END);
    // get the position of the pointer: will give us how big is the file
    input_file_size = ftell(input_file);
    // go back at the beginning of the file
    rewind(input_file);
    // allocate memory for file contents
    filecontents = malloc(input_file_size * (sizeof(char)));
    // read the file regardless of newlines
    fread(filecontents, sizeof(char), input_file_size, input_file);
    // close the file
    fclose(input_file);
    
    //print the content of the variable
    printf("%s",filecontents);
	return 0;
}
