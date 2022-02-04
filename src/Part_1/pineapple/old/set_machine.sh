#!/bin/bash

# Add secret to application 
FILE=application/machine.tfvars
if test -f "$FILE"; then
    echo "$FILE exists."
else 
    echo vm_size = '"'${1}'"' > application/vm-size.tfvars
fi 

