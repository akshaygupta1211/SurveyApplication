#!/bin/bash

#Check if changed-sources contain salesforce changes
if [[ -d changed-sources/force-app/main/default ]]
then
    echo "Changes detected in following file(s):"
    #Loop through all the files and print the name
    for file in changed-sources/force-app/main/default/*/*
    do
        echo "${file##*/}"
    done
fi
