#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  readgames.py
#  
#  Copyleft 2016 Florido Paganelli <florido.paganelli@hep.lu.se>
#  
#
#  

def main():
    # open the file as f
    with open('../../data/nintendowiigames.xml','r') as f:
        # read the whole contents
        contents = f.read();
    # close the file
    f.close();
    # output the contents
    print contents;
    return 0

if __name__ == '__main__':
	main()
