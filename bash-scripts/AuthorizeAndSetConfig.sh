#!/bin/bash

#Copy jwt token
echo "${JWT_KEY}" > jwt.key

#Authorize with the org
sf org login jwt --username ${USER_NAME} --jwt-key-file jwt.key --client-id ${CLIENT_KEY} --alias ci-org --set-default