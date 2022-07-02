#!/bin/bash

if [[ -d changed-sources/force-app/main/default/classes ]]
then
    cd changed-sources/force-app/main/default/classes
    FILES=$(ls *.cls)
    FILE_NAMES=""
    for file in $FILES
    do
        FILE_NAMES+="$file,"
    done
    echo $FILE_NAMES
fi