#!/bin/bash

#If changes detected are salesforce related code changes
if [[ -d ${REPO_NAME}/changed-sources/force-app/main/default ]]
then 
    sfdx scanner:run --target "${{ github.event.repository.name }}/changed-sources/force-app/main/default" --engine "eslint-lwc,retire-js,cpd,pmd" --verbose
#If changes detected are not salesforce related code changes
else
then
    echo "No code change detected to run scan"
fi