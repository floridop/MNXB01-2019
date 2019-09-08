/*
 * readgames.cpp
 * 
 * Copyleft 2016 Florido Paganelli <florido.paganelli@hep.lu.se>
 * 
 */

// library for basic input/output
#include <iostream>
// library for files stream
#include <fstream>
// library for strings stream
#include <sstream>
// library for strings
#include <string>
// if not specified, the functions belong to the std namespace
using namespace std;

int main(int argc, char **argv)
{
    // create a stream of strings
    std::stringstream filecontents;
    // create an input file stream
	ifstream myfile;
    // open the nintendowiigames.xml file as a file stream 
	myfile.open ("../../data/nintendowiigames.xml");
    // if the open was successfull
	if (myfile.is_open()) 
	{
       // stream the contents of the file inside the string stream
       filecontents << myfile.rdbuf();
	}
    // close the file
	myfile.close();
    // convert the stream to a string
    string contents(filecontents.str());
    // print out the string
    cout << contents;
	return 0;
}
