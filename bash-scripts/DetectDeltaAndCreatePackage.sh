#!/bin/bash

git clone ${SERVER_URL}/${REPOSITORY}

cd ${REPO_NAME}

git checkout ${BRANCH}

mkdir changed-sources 

sfdx sgd:source:delta --source force-app/main/default --to "HEAD" --from "HEAD^" --output changed-sources/ --generate-delta

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