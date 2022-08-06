#!/bin/bash

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
        sfdx force:source:deploy -c -x ${REPO_NAME}/changed-sources/package/package.xml --verbose
    #If changes detected in class(es) run specified test class(es) and validation  
    else
        echo "Running validation with test class(es)"
        sfdx force:source:deploy -c -x ${REPO_NAME}/changed-sources/package/package.xml --testlevel RunSpecifiedTests --runtests "${PR_BODY}" --verbose
    fi
    unset FILE_NAMES
fi        