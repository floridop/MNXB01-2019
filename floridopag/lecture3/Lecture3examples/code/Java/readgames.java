/*
 * readgames.java
 * 
 * Copyleft 2016 Florido Paganelli <florido.paganelli@hep.lu.se>
 * 
 */
 
// import basic input/output java libraries 
import java.io.*;
// import java utility Scanner
import java.util.Scanner;

// everything is a class in java
public class readgames {
    // cause specific file errors in case of problems	
	public static void main (String args[]) throws FileNotFoundException, IOException {

        String text = new Scanner( new File("../../data/nintendowiigames.xml") ).useDelimiter("\\A").next();
        // try this code
        try {    
            // create an output buffer to standard output
            BufferedWriter output = new BufferedWriter(new OutputStreamWriter(System.out));
            // write the content of text on output
            output.write(text);
            // empty the content of standard out to screen
            output.flush();
        }
        // print an error if it fails
        catch (Exception e) {
            e.printStackTrace();
        }
	}
}
