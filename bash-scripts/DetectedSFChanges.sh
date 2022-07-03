#!/bin/bash

#Check if changed-sources contain salesforce changes
ls -la
if [[ -d changed-sources/force-app/main/default ]]
then
    echo "Changes detected in following file(s):"
    #Loop through all the test classes files and store the names in csv format    
    for file in changed-sources/force-app/main/default/*/*
    do
        echo "${file##*/}"
    done
fi
