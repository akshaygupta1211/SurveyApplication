#!/bin/bash
#
# Generates package.xml for changed files.

# Constants
readonly CHANGED_SRC_LIST_FILE='ChangedFileNames.txt'
readonly SFDC_PACKAGE_CHANGE_DIR='src/package.xml'
readonly OUTPUT_XML_FILE='package.xml'
readonly API_VERSION=56.0
readonly jsonData='v56.json'
readonly source=$0
readonly destination=$1

# Declare an empty array variable
declare -a lines
declare -a exceptional_metadata=("customMetadata" "quickActions")

# Parse the JSON text using jq and store the result in an associative array
declare -A metadata_array
declare -A exceptional_metadata_suffix
exceptional_metadata_suffix['customMetadata']=.md
exceptional_metadata_suffix['quickActions']=.quickAction

eval $(jq -r 'to_entries[] | @sh "metadata_array[\(.key|tostring)]=\(.value)"' < $jsonData)

# Making sure the file is empty.
rm -f "${OUTPUT_XML_FILE}"
touch "${OUTPUT_XML_FILE}"
rm -f "${CHANGED_SRC_LIST_FILE}"
touch "${CHANGED_SRC_LIST_FILE}"

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> "${OUTPUT_XML_FILE}"
echo "<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">" >> "${OUTPUT_XML_FILE}"

git diff $source..$destination --name-only > "${CHANGED_SRC_LIST_FILE}"

readarray -t lines < "$CHANGED_SRC_LIST_FILE"

i=1
previous_file=''

for line in "${lines[@]}"
do
  echo "Processing file(s) "$i" out of ${#lines[@]}" 
  if [[ "$line" == *"$SFDC_PACKAGE_CHANGE_DIR"* ]] || [[ "$line" != *"src/"* ]]; then
    continue
  else
    directory_name=$(echo "${line}" | cut -d'/' -f2)
    if [[ "${exceptional_metadata[*]}" =~ "$directory_name" ]]; then
      temp_line=$(echo "${line}" | cut -d'/' -f3)
      file_name=$(echo ${temp_line//$(echo "${exceptional_metadata_suffix[$directory_name]}")})
    else
      file_name=$(echo "${line}" | cut -d'/' -f3 | cut -d'.' -f1)
    fi
    metadata_name=$(echo ${metadata_array[$directory_name]})
    if [[ "$previous_file" != "$file_name" ]]; then
      echo "  <types>" >> "${OUTPUT_XML_FILE}"
      echo "    <member>${file_name}</member>" >> "${OUTPUT_XML_FILE}"
      echo "    <name>${metadata_name}</name>" >> "${OUTPUT_XML_FILE}"
      echo "  </types>" >> "${OUTPUT_XML_FILE}"
    fi  
  fi
  i=$((i+1))
  previous_file=$file_name
done
echo "  <version>${API_VERSION}</version>" >> "${OUTPUT_XML_FILE}"
echo "</Package>" >> "${OUTPUT_XML_FILE}"
echo "Processing Completed!!"