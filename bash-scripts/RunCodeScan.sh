#!/bin/bash

set -euo pipefail

#If changes detected are salesforce related code changes
if [[ -d ${REPO_NAME}/changed-sources/force-app/main/default ]]
then 
    sf scanner:run --target "${REPO_NAME}/changed-sources/force-app/main/default" --engine "eslint-lwc,retire-js,cpd,pmd" --verbose
    exit_code=$?
    if [[ $exit_code -eq 0 ]]; then
        echo "Validation succeeded."
        exit 0
    else
        echo "Validation failed with exit code $exit_code."
        exit $exit_code
    fi    
#If changes detected are not salesforce related code changes
else
    echo "No code change detected to run scan"
    exit 0
fi