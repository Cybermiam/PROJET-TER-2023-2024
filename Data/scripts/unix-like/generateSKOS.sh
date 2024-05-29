#!/bin/bash
#
# generateSKOS.sh
#
# generates a SKOS ttl or trig file from a tsv file using tarql (see : https://tarql.github.io/).
#
# usage: generateVoc [-h] [-g graphName] file
#
# options :
# -h : help
# -g graphname : to create a named graph 'graphName' 
# -f : to format the output file using riot
#
# parameters :
#
# - file : the name (without file extension) of the .tsv input files
#
# examples :
#  generateSKOS -f denomination
#
#     takes ../inputData/thesaurus/denomination.tsv file, applies on it ../tarql/generateSKOS.tarql
#     and generates a formatted .ttl file  in ../triple_store_data/thesaurus/qualifications.ttl 
#
#  generateSKOS -g thesaurus denomination    
#  
#     takes ../inputData/thesaurus/denomination.tsv file, applies on it ../tarql/generateSKOS.tarql
#     and generates the .trig file  ../triple_store_data/thesaurus/qualifications.trig with named 
#     graph brocartsgraph:thesaurus

#number of arguments
arg_count=$#
#number of args used by options
option_arg_count=0
# name of graph is option -g is used
graph_name=""
# flag for named graph
named_graph=0
# flag for formatted file
formatted_file=0

# Parse the options
while getopts "hfg:" opt; do
 ((option_arg_count++))
  case "${opt}" in
    h)
      echo "Usage: generateSKOS [-h] [-g graphName] [-f] file"
      echo -e "\nOptions:"
      echo -e "\t-h : help"
      echo -e "\t-g graphname : to create a named graph 'graphName'"
      echo -e "\t-f : to format the output file using riot"
      exit 0
      ;;
    g)
      graph_name="${OPTARG}"
      ((option_arg_count++))
      named_graph=1
      ;;
    f)
      formatted_file=1
      ;;
    \?)
      echo "Invalid option: -${OPTARG}" >&2
      exit 1
      ;;
  esac
done

# Test if arg_count equals option_arg_count + 1
if [[ ${arg_count} -eq $((option_arg_count + 1)) ]]; then
  # skos file name value is the value of the last argument
  skos_file_name=${!#}
  echo "generating SKOS for : '${skos_file_name}'"
  tarql -t --dedup 5000 ../../tarql/generateSKOS.tarql ../../inputData/thesaurus/${skos_file_name}.tsv > tmp.ttl
  if [[ ${named_graph} -eq 1 ]]; then
    echo -e "\tsaving SKOS in '${skos_file_name}.trig' with named graph '${graph_name}'"
    echo -e "\tadding named graph '${graph_name}'"
    ./addNamedGraph.sh tmp.ttl ${graph_name} tmp.trig 
    if [[ ${formatted_file} -eq 1 ]]; then
      echo -e "\tusing riot to format the file"
      riot --formatted=trig tmp.trig > ../../triple_store_data/thesaurus/${skos_file_name}.trig
    else
      mv tmp.trig ../../triple_store_data/thesaurus/${skos_file_name}.trig
    fi
    echo -e "\tremoving temporary files"
    rm tmp.*
  else
    echo -e "\tsaving SKOS in '${skos_file_name}.ttl'"
    if [[ ${formatted_file} -eq 1 ]]; then
      echo -e "\tusing riot to format the file"
      riot --formatted=turtle tmp.ttl > ../../triple_store_data/thesaurus/${skos_file_name}.ttl
      echo -e "\tremoving temporary files"
      rm tmp.*
    else
      mv tmp.ttl ../../triple_store_data/thesaurus/${skos_file_name}.ttl
    fi
  fi

else
  echo "Error: No filename provided."
  echo "Usage: generateVoc [-h] [-g graphName] file"
  exit 1
fi



