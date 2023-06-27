#!/bin/bash

jsonlint_output_log_file="jsonlint_output.log"

if [[ -d ${REPO_NAME}/changed-sources/force-app/main/default/staticresources ]]
then
    json_files=($(find ${REPO_NAME}/changed-sources/force-app/main/default/staticresources -type f -name "*.json"))
    if [[ ${#json_files[@]} -ne 0 ]]
    then
        echo "Change(s) detected in JSON file(s) in static resource"
    fi
    for file in "${json_files[@]}"
    do
        echo "Checking ${file}"
        npx jsonlint $file > ${jsonlint_output_log_file}
    done
fi

for line in "${jsonlint_output_log_file[@]}"; do
    if [[ "$line" == *"error"* ]] || [[ "$line" == *"Error"* ]]
    then
        return 1
    fi
done