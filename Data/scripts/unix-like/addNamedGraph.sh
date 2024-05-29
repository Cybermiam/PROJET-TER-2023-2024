#!/bin/bash
set -e

#transforms a turtle file in a trig file.
# 
#adds a named graph declaration in the first empty line after prefixes
#and adds a closing bracket at the end of the file for closing the named graph
#
#parameters:
#  $1 name of the input file
#  $2 the name of the Named graph
#  $3 the name of the ouput .trig file
#
#example :     addNamedGraph  ../triple_store_data/qualifications.ttl brocartsThesaurus ../triple_store_data/qualifications.trig
#
# the script use sed (or gsed on macOS) to add the named graph declaration in the first empty line after prefixes
# (see https://stackoverflow.com/questions/45105935/sed-to-find-the-first-empty-line-after-match-and-replace)
# and add a closing bracket at the end of the file for closing the named graph
#
if [[ "$OSTYPE" == "darwin"* ]]; then
    # "Running on macOS"
    # add the named graph declaration in the first empty line after prefixes"
    gsed '/^@prefix/!b;:a;n;/./ba;ibrocartsgraph:'$2' \{' $1 > $3
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Running on Ubuntu or another Linux distribution"
    # add the named graph declaration in the first empty line after prefixes"
    sed '/^@prefix/!b;:a;n;/./ba;ibrocartsgraph:'$2' \{' $1 > $3
else
    echo -e "\t\taddNamedGraph.sh : Unsupported operating system"
    exit 1
fi
#add a closing bracket at the end of the file for closing the named graph
echo } >> $3