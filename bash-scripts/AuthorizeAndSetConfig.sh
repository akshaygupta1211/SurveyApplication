#!/bin/bash

#Copy jwt token
echo "${JWT_KEY}" > jwt.key

#Authorize with the org
sfdx auth:jwt:grant --client-id ${CLIENT_KEY} --jwt-key-file jwt.key --username ${USER_NAME}

#Set configuration
sfdx config:set defaultusername=${USER_NAME}