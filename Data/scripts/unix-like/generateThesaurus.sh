#!/bin/bash

# generateThesaurus.sh

#
# generates the whole thesaurus for Brocarts that defines possible values for the various
# enumerations defined in the brocarts data model.
#
# usage: generateThesaurus
#
# three files are generated in the triple_store_data/thesaurus directory:
#
# - brocartsThesaurus.ttl : a formatted turtle file
# - brocartsThesaurus.trig : a formatted trig file with a named graph brocartsThesaurus
# - brocartsThesaurusOnto.ttl : a formatted turtle file which is the OWL ontology file for the thesaurus
#                               this file is also copied in the Ontologies directory
#

echo "------- [ generateThesaurus.sh] -------"

echo "---- Deleting old TriG files: $fileName"
rm ../../triple_store_data/thesaurus/*.ttl

set -e
find ../../inputData/thesaurus -type f -name '*.tsv' -print0 | while read -d $'\0' X; do
    fileFullName=$(basename "$X")
    fileName=${fileFullName%.*}
    echo "---- Currently modifying: $fileName"
    if ! ./generateSKOS.sh $fileName; then
        echo -e "\tError: failed to generate SKOS data for $fileName"
        exit 1
    fi
done

outputDir="../../triple_store_data/thesaurus"
cd "$outputDir"

echo "---- Merging all .ttl files into one"
cat *.ttl > merged.ttl

echo "---- Formatting merged .ttl files"
if ! riot --formatted=turtle merged.ttl > ../brocartsThesaurus.ttl; then
  echo "Error: failed to format merged turtle files"
  exit 1
fi
echo "Done: a new version of brocartsThesaurus.ttl was generated"

echo "---- Transforming brocartsThesaurus.ttl into brocartsThesaurus.trig"
../../scripts/unix-like/addNamedGraph.sh ../brocartsThesaurus.ttl brocartsThesaurus ./merged.trig

if ! riot --formatted=trig merged.trig > ../brocartsThesaurus.trig; then
  echo "Error: failed to merge trig files"
  exit 1
fi
echo "Done: a new version of brocartsThesaurus.trig was generated"

echo "---- creating  brocartsThesaurus owl onology file"

# The file to modify
file="../brocartsThesaurus.ttl"

# Use awk to insert the text after the first blank line
awk 'BEGIN {p=1} !NF && !f {print; system("cat"); f=1; next} p' "${file}" > ../brocartsThesaurusOnto.ttl <<'EOF' 
<http://patrimalp.org/brocarts/thesaurus> a owl:Ontology ;
	owl:versionIRI <http://patrimalp.org/brocarts/thesaurus/1.0> ;
	owl:imports <http://www.w3.org/2004/02/skos/core> ;
	rdfs:comment "Ontologie définissant les concepts SKOS permettant de déclarer les valeurs des propriétés énumérées décrivant les brocarts"@fr .

EOF
cp ../brocartsThesaurusOnto.ttl ../../Ontologies/brocartsThesaurusOnto.ttl
echo "---- Deleting temporary files"
rm merged.*
echo "---- Done"
cd "$OLDPWD"
exit 0
