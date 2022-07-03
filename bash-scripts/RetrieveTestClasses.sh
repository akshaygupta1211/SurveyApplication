#!/bin/bash

#Check if changed-sources contain classes
if [[ -d changed-sources/force-app/main/default/classes ]]
then
    #Loop through all the test classes files and store the names in csv format    
    for file in changed-sources/force-app/main/default/classes/*Test.cls
    do
        FILE_NAMES+="$file,"
    done
    FILE_NAMES=${FILE_NAMES:0:${#FILE_NAMES}-1}
fi

#If no changes detected in test class(es) just run validation
if [ ${#FILE_NAMES} == 0 ]
then
    sfdx force:source:deploy -c -x ${REPO_NAME}/changed-sources/package/package.xml
#If changes detected in test class(es) run test class(es) and validation  
else
    sfdx force:source:deploy -c -x ${REPO_NAME}/changed-sources/package/package.xml --testlevel RunSpecifiedTests --runtests "${FILE_NAMES}" 
fi    