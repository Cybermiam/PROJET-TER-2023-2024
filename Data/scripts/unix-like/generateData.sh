#!/bin/bash
set -e

#generates a trig file from a tsv file using tarql (see : https://tarql.github.io/).
#The .tsv file containing the data and the .tarql file containing the CONSTRUCT query
#MUST have the same name, just the suffixes differ (.tsv for the first, .tarql for the second).

#parameters :
#$1 the name (without file extension) of the .tsv and .tarql input files 
#$2 the name of the Named graph

#example :     generateData brocartsAppliques brocartsData
 
#takes ../inputData/brocartsAppliques.tsv file, applies on it the ../tarql/brocartsAppliques.tarql and
#generates the .trig file  ../triple_store_data/data/brocartsAppliques.trig

echo -e "\tGenerating the TRiG file for: " $1
tarql -t ../../tarql/$1.tarql ../../inputData/data/$1.tsv > tmp.ttl
echo -e "\t\tAdding a named graph: $2"
./addNamedGraph.sh tmp.ttl $2 tmp.trig
# use riot to format the file
riot --formatted=trig tmp.trig > ../../triple_store_data/data/$1.trig
rm tmp.ttl tmp.trig
