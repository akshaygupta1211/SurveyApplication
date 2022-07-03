#!/bin/bash

#Check if changed-sources contain salesforce changes
if [[ -d ${REPO_NAME}/changed-sources/force-app/main/default ]]
then
    FILE_NAMES=""
    #Check if changed-sources contain classes
    if [[ -d ${REPO_NAME}/changed-sources/force-app/main/default/classes ]]
    then
        #Loop through all the test classes files and store the names in csv format 
        for file in ${REPO_NAME}/changed-sources/force-app/main/default/classes/*Test.cls
        do
            FILE_NAMES+="$(basename ${file} .cls),"
        done
        FILE_NAMES=${FILE_NAMES:0:${#FILE_NAMES}-1}
    fi

    echo "Changes detected in following test class(es): ${FILE_NAMES}"
    
    #If no changes detected in test class(es) just run validation
    if [ "${FILE_NAMES}" == "*Test" ]
    then
        echo "Running validation"
        sfdx force:source:deploy -c -x ${REPO_NAME}/changed-sources/package/package.xml --verbose
    #If changes detected in test class(es) run test class(es) and validation  
    else
        echo "Running validation with test class(es)"
        sfdx force:source:deploy -c -x ${REPO_NAME}/changed-sources/package/package.xml --testlevel RunSpecifiedTests --runtests "${FILE_NAMES}" --verbose
    fi
    unset FILE_NAMES
fi        