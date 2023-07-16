#!/bin/bash

set -euo pipefail

#Check if changed-sources contain salesforce changes
if [[ -d ${REPO_NAME}/changed-sources/force-app/main/default ]]
then
    FILE_NAMES=""
    #Check if changed-sources contain classes
    if [[ -d ${REPO_NAME}/changed-sources/force-app/main/default/classes ]]
    then
        #Loop through all the classes files and store the names in csv format 
        for file in ${REPO_NAME}/changed-sources/force-app/main/default/classes/*.cls
        do
            FILE_NAMES+="$(basename ${file} .cls),"
        done
        FILE_NAMES=${FILE_NAMES:0:${#FILE_NAMES}-1}
    fi

    if [ ${#FILE_NAMES} != 0 ]
    then
        echo "Changes detected in following class(es): ${FILE_NAMES}"
    else
        echo "No class changes detected!"
    fi    
    
    #If no changes detected in class(es) just run validation
    if [ "${FILE_NAMES}" == "" ] 
    then
        echo "Running validation"
        sf project deploy validate -x ${REPO_NAME}/changed-sources/package/package.xml --test-level NoTestRun --verbose
        exit_code=$?
        if [[ $exit_code -eq 0 ]]; then
            echo "Validation succeeded."
            exit 0
        else
            echo "Validation failed with exit code $exit_code."
            exit $exit_code
        fi        
    #If changes detected in class(es) run specified test class(es) and validation
    else
        echo "Running validation with test class(es)"
        sf project deploy validate -x ${REPO_NAME}/changed-sources/package/package.xml --test-level RunSpecifiedTests --tests "${PR_BODY}" --verbose
        exit_code=$?
        if [[ $exit_code -eq 0 ]]; then
            echo "Validation with test class(es) succeeded."
            unset FILE_NAMES
            exit 0
        else
            echo "Validation with test class(es) failed with exit code $exit_code."
            unset FILE_NAMES
            exit $exit_code
        fi        
    fi
fi
echo "No Salesforce changes detected."
exit 0