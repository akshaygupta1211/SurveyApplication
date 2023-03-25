#!/bin/bash
#
# This is a Bash script that generates a package.xml file based on the changes made to files in a Salesforce development environment. 
# The script uses Git to obtain a list of changed files between two brnaches and copies the changed files to a working directory. 
# It then reads through the list of changed files and generates a package.xml file based on the metadata type of the files.
# The script uses two JSON files to map Salesforce directory names to their corresponding metadata types and to determine 
# whether a metadata file exists for a given directory. It also handles exceptions for certain metadata types that have non-standard naming conventions.
# The generated package.xml file is written to the working directory and can be used to deploy the changed files to another Salesforce org.

set -euo pipefail

# Constants
declare -r SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
declare -r WORKING_DIR=$(pwd)"/delta-changes"
declare -r SFDC_PACKAGE_CHANGE_DIR="src/package.xml"
declare -r OUTPUT_XML_FILE="$WORKING_DIR/package.xml"
declare -r CHANGED_SRC_LIST_FILE="$SCRIPT_PATH/ChangedFileNames.txt"
declare -r DIR_XML_NAME_JSON_DATA="$SCRIPT_PATH/DirectoryXMLName_v56.json"
declare -r DIR_NAME_META_FILE_JSON_DATA="$SCRIPT_PATH/DirectoryNameMetafile_v56.json"
declare -r API_VERSION=51.0

declare -a lines
declare -a exceptional_metadata=("customMetadata" "quickActions")

declare -A exceptional_metadata_suffix=(
  ["customMetadata"]=".md"
  ["quickActions"]=".quickAction"
)

# Parse the JSON text using jq and store the result in an associative array
declare -A dir_xml_name_array

eval $(jq -r 'to_entries[] | @sh "dir_xml_name_array[\(.key|tostring)]=\(.value)"' < $DIR_XML_NAME_JSON_DATA)

declare -A dir_meta_file_exist_array

eval $(jq -r 'to_entries[] | @sh "dir_meta_file_exist_array[\(.key|tostring)]=\(.value)"' < $DIR_NAME_META_FILE_JSON_DATA)


# Creating directory to store changed sources and package.xml
if [[ -d "$WORKING_DIR" ]]; then
  rm -Rf $WORKING_DIR || { echo "Error removing directory $WORKING_DIR"; exit 1; }
fi

mkdir -p $WORKING_DIR || { echo "Error creating directory $WORKING_DIR"; exit 1; }

if [[ -f "$CHANGED_SRC_LIST_FILE" ]]; then
  rm $CHANGED_SRC_LIST_FILE || { echo "Error removing file $CHANGED_SRC_LIST_FILE"; exit 1; }
fi

touch $OUTPUT_XML_FILE || { echo "Error creating file $OUTPUT_XML_FILE"; exit 1; }
touch $CHANGED_SRC_LIST_FILE || { echo "Error creating file $CHANGED_SRC_LIST_FILE"; exit 1; }

pushd "$3" && git diff "$1..$2" --name-only --diff-filter=ACMRTUXB > "${CHANGED_SRC_LIST_FILE}" && popd || { echo "Error getting changed files list"; exit 1; }

while read line; do
  if [[ "$line" == *"src/"* ]] && [[ "$line" != *"src/package.xml"* ]]; then
    directory_name=$(echo "${line}" | cut -d'/' -f2)
    meta_file_exist=$(echo ${dir_meta_file_exist_array[$directory_name]})
    install -Dv $3"/${line}" $WORKING_DIR/"${line}" || { echo "Error copying file $line to $WORKING_DIR"; exit 1; }
    if [[ "$meta_file_exist" == true ]]; then
      install -Dv $3"/${line}-meta.xml" $WORKING_DIR/"${line}-meta.xml" || { echo "Error copying meta file $line-meta.xml to $WORKING_DIR"; exit 1; }
    fi
  fi
done < "${CHANGED_SRC_LIST_FILE}"

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> "${OUTPUT_XML_FILE}"
echo "<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">" >> "${OUTPUT_XML_FILE}"

# Reading the file as an array
readarray -t lines < "$CHANGED_SRC_LIST_FILE"

iterator=1
previous_file=""

# Skipping NON-SFDC and package.xml changes and appending relevant changes to package.xml
for line in "${lines[@]}"; do
  echo "Processing file(s) "$iterator" out of " ${#lines[@]}
  if [[ "$line" == *"src/"* ]] && [[ "$line" != *"src/package.xml"* ]]; then
    directory_name=$(echo "${line}" | cut -d'/' -f2)
    if [[ "${exceptional_metadata[*]}" =~ "$directory_name" ]]; then
      temp_line=$(echo "${line}" | cut -d'/' -f3)
      file_name=$(echo ${temp_line//$(echo "${exceptional_metadata_suffix[$directory_name]}")})
    else
      file_name=$(echo "${line}" | cut -d'/' -f3 | cut -d'.' -f1)
    fi
    metadata_name=$(echo ${dir_xml_name_array[$directory_name]})
    if [[ "$previous_file" != "$file_name" ]]; then
      echo "  <types>" >> "${OUTPUT_XML_FILE}"
      echo "    <members>${file_name}</members>" >> "${OUTPUT_XML_FILE}"
      echo "    <name>${metadata_name}</name>" >> "${OUTPUT_XML_FILE}"
      echo "  </types>" >> "${OUTPUT_XML_FILE}"
    fi
  fi
  iterator=$((iterator+1))
  previous_file=$file_name
done

echo "  <version>${API_VERSION}</version>" >> "${OUTPUT_XML_FILE}"
echo "</Package>" >> "${OUTPUT_XML_FILE}"

rm "$CHANGED_SRC_LIST_FILE" || { echo "Error: Failed to remove file $CHANGED_SRC_LIST_FILE"; exit 1; }
mv "${OUTPUT_XML_FILE}" "$WORKING_DIR/src/package.xml" || { echo "Error: Failed to move package.xml file"; exit 1; }

echo "Processing Completed!!"