#!/bin/bash

eslint_output_log_file="eslint_output.log"

if [[ -d ${REPO_NAME}/changed-sources/force-app/main/default/staticresources ]]
then
    echo "Change(s) detected in Javascript file(s) in static resource"
    for file in ${REPO_NAME}/changed-sources/force-app/main/default/staticresources/*.js
    do
        echo "Checking ${file}"
        npx eslint $file > ${eslint_output_log_file}
    done    
fi

if [[ -d ${REPO_NAME}/changed-sources/force-app/main/default/aura ]]
then
    echo "Change(s) detected in Javascript file(s) in aura"
    for file in ${REPO_NAME}/changed-sources/force-app/main/default/aura/*.js
    do
        echo "Checking ${file}"
        npx eslint $file > ${eslint_output_log_file}
    done    
fi

if [[ -d ${REPO_NAME}/changed-sources/force-app/main/default/lwc ]]
then
    echo "Change(s) detected in Javascript file(s) in aura"
    for file in ${REPO_NAME}/changed-sources/force-app/main/default/lwc/*.js
    do
        echo "Checking ${file}"
        npx eslint $file > ${eslint_output_log_file}
    done    
fi

for line in "${eslint_output_log_file[@]}"; do
    if [[ "$line" == *"error"* ]] || [[ "$line" == *"Error"* ]]
    then
        return 1
    fi
done