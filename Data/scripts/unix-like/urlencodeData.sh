#!/bin/bash

TSV_DIR=../../inputData/data

urlencode() {
  local string="$1"
  local length="${#string}"
  local encoded=""

  for (( i = 0; i < length; i++ )); do
    local char="${string:i:1}"

    if [[ "$char" =~ [a-zA-Z0-9\.\_\-\~] ]]; then
      encoded+="$char"
    else
      local ascii_val=$(printf "%d" "'$char")
      encoded+="%$(printf "%X" "$ascii_val")"
    fi
  done

  echo "$encoded"
}

#
for file in $TSV_DIR/*.tsv; do
    echo "Processing $file..."
    cp "$file" "$file.bak"
    while IFS=$'\t' read -r -a fields; do
        encoded_fields=()
        for field in "${fields[@]}"; do
            encoded_fields+=("$(urlencode "$field")")
        done
        echo "${encoded_fields[*]}" | tr ' ' '\t' >> "$file.tmp"
    done < "$file"
    mv "$file.tmp" "$file"
    rm "$file.bak"
done