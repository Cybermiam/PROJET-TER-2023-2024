#!/bin/bash
set -e
clear
echo "------- [ generateAllData.sh] -------"

echo "---- Deleting old TriG files: $fileName"
rm -f ../../triple_store_data/data/*.trig

find ../../inputData/data -type f -name '*.tsv' -print0 | while read -d $'\0' X; do
    fileFullName=$(basename "$X")
    fileName=${fileFullName%.*}
    echo "---- Currently modifying: $fileName"
    if ! ./generateData.sh "$fileName" brocartsData; then
        echo -e "\tError: failed to generate data for $fileName"
        exit 1
    fi
done

outputDir="../../triple_store_data/data"
cd "$outputDir"
if ! riot --formatted=TRIG *.trig > ../brocartsData.trig; then
    echo "Error: failed to merge trig files"
    exit 1
fi
cd "$OLDPWD"

echo "Done: a new version of brocartsData.trig was generated"
