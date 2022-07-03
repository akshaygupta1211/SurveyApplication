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

fi

if [ ${#FILE_NAMES} == 0 ]
then
    sfdx force:source:deploy -c -x ${{ github.event.repository.name }}/changed-sources/package/package.xml
else
    sfdx force:source:deploy -c -x ${{ github.event.repository.name }}/changed-sources/package/package.xml --classnames "${FILE_NAMES}" --resultformat tap --codecoverage    