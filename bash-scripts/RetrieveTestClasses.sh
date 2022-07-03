#!/bin/bash

#Check if changed-sources contain classes
if [[ -d changed-sources/force-app/main/default/classes ]]
then
    #Change the current directory to classes
    cd changed-sources/force-app/main/default/classes
    
    FILES=$(ls *Test.cls)
    FILE_NAMES=""
    
    #Loop through all the files and store the names in csv format    
    for file in $FILES
    do
        FILE_NAMES+="$file,"
    done
    FILE_NAMES=${FILE_NAMES:0:${#FILE_NAMES}-1}
fi

if [ ${#FILE_NAMES} == 0 ]
then
    sfdx force:source:deploy -c -x ${REPO_NAME}/changed-sources/package/package.xml
else
    sfdx force:source:deploy -c -x ${REPO_NAME}/changed-sources/package/package.xml --testlevel RunSpecifiedTests --runtests "${FILE_NAMES}" 
fi    