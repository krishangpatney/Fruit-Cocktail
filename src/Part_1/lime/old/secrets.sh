#!/bin/bash

# Add secret to application 
FILE=application/secret-variables.tfvars
if test -f "$FILE"; then
    echo "$FILE exists."
else 
    echo subscription_id = '"'${1}'"' > application/secret-variables.tfvars
fi 
<<<<<<< HEAD:src/Part_1/lime/old/secrets.sh

# If override needed do 
if [ "$2" = "override" ]; then
    echo subscription_id = '"'${1}'"' > application/secret-variables.tfvars
    # echo subscription_id = '"'${1}'"' > load/secret-variables.tfvars
fi
=======
>>>>>>> 8dc0bf78774f5109ba6895cc6ba32e4cb79c8051:src/Part_2/orange/secrets.sh
