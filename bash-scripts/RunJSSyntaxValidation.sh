#!/bin/bash

eslint_output_log_file="eslint_output.log"

if [[ -d ${REPO_NAME}/changed-sources/force-app/main/default/staticresources ]]
then
    js_files=($(find ${REPO_NAME}/changed-sources/force-app/main/default/staticresources -type f -name "*.js"))
    if [[ ${#js_files[@]} -ne 0 ]]
    then
        echo "Change(s) detected in JSON file(s) in static resource"
    fi
    for file in "${js_files[@]}"
    do
        echo "Checking ${file}"
        npx eslint $file >> ${eslint_output_log_file}
    done    
fi

if [[ -d ${REPO_NAME}/changed-sources/force-app/main/default/aura ]]
then
    js_files=($(find ${REPO_NAME}/changed-sources/force-app/main/default/aura -type f -name "*.js"))
    if [[ ${#js_files[@]} -ne 0 ]]
    then
        echo "Change(s) detected in Javascript file(s) in aura"
    fi
    echo "Change(s) detected in Javascript file(s) in aura"
    for file in "${js_files[@]}"
    do
        echo "Checking ${file}"
        npx eslint $file >> ${eslint_output_log_file}
    done    
fi

if [[ -d ${REPO_NAME}/changed-sources/force-app/main/default/lwc ]]
then
    js_files=($(find ${REPO_NAME}/changed-sources/force-app/main/default/lwc -type f -name "*.js"))
    if [[ ${#js_files[@]} -ne 0 ]]
    then
        echo "Change(s) detected in Javascript file(s) in lwc"
    fi
    for file in "${js_files[@]}"
    do
        echo "Checking ${file}"
        npx eslint $file >> ${eslint_output_log_file}
    done    
fi

cat $eslint_output_log_file

for line in "${eslint_output_log_file[@]}"; do
    if [[ "$line" == *"error"* ]] || [[ "$line" == *"Error"* ]]
    then
        return 1
    fi
done