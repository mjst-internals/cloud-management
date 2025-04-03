#!/bin/bash
## =================================================================================================
## Description : First server start initialization script
## Author      : Michael J. Stallinger
## Version     : 0.0.1
## License     : MIT
## =================================================================================================
## Usage:
##      ./init.sh [--user <user_name>]
##
## Parameters:
##      --user <user_name>      user to be created
##
## Requirements:
##      - Bash
##
## Notes:
##      - Make sure you have appropriate rights to execute the script.
## =================================================================================================
set -euo pipefail

# arguments
user_name="";
while [[ $# -gt 0 ]]
do
    case "$1" in
        --user)
            user_name="$(echo "$2" | xargs)"; # trim user_name
            # check for username
            if [ -z "${user_name}" ]
            then
                echo "Required argument: --user"
                exit 1    
            fi
            shift 2;
            ;;
        -h|--help)
            grep '^##' "$0" | sed 's/^## \{0,1\}//';
            exit 0;
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;            
    esac
done

# create new user and move keys over
bash ./init_user_create.sh --user "${user_name}"
# harden ssh configuration
bash ./hardening_ssh.sh --user "${user_name}"
