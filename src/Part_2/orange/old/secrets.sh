#!/bin/bash

# Add secret to application 
FILE=application/secret-variables.tfvars
if test -f "$FILE"; then
    echo "$FILE exists."
else 
    echo subscription_id = '"'${1}'"' > application/secret-variables.tfvars
fi 
