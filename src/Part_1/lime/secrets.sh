#!/bin/bash

# Add secret to application 
FILE=application/secret-variables.tfvars
if test -f "$FILE"; then
    echo "$FILE exists."
else 
    echo subscription_id = '"'${1}'"' > application/secret-variables.tfvars
fi 

# If override needed do 
if [ "$2" = "override" ]; then
    echo subscription_id = '"'${1}'"' > application/secret-variables.tfvars
    # echo subscription_id = '"'${1}'"' > load/secret-variables.tfvars
fi
