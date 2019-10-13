#include <iostream>
using namespace std;
int globalScope = 0; //This is a global variable, visible everywhere.

void foo() {
    int fooScope = 1; //Only visible within foo function
    cout << "fooScope: " << fooScope << endl;
    cout << "localScope: " << localScope << endl; 
}
int main() {
    cout << "globalScope: " << globalScope << endl;

    { //Any block declares a scope, even this useless one
        int localScope = 3; 
        cout << "localScope: " << localScope << endl;
        foo();
        cout << "fooScope: " << fooScope << endl; 
        int globalScope = 100; // variable hiding, very bad practice!
        cout << "globalScope: " << globalScope << endl;
    }
    cout << "localScope: " << localScope << endl;
    cout << "globalScope: " << globalScope << endl;
}
