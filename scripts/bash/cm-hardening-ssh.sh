#!/bin/bash
## =================================================================================================
## Description : Hardening settings for SSH/SSHD
## Author      : Michael J. Stallinger
## =================================================================================================
## Usage:
##      ./cm-hardening-ssh.sh [--user <user_name>] [--skip-restart]
##
## Parameters:
##      --user <user_name>      optional, make sure to pass an existing user
##      --skip-restart          optional, does not test and restart the sshd service (for now)
##
## Requirements:
##      - Bash
##
## Notes:
##      - Make sure you have appropriate rights to execute the script!
##      - Creates a backup file of sshd_config beforehand.
##      - Compare original config with `diff /usr/share/openssh/sshd_config /etc/ssh/sshd_config`;
## =================================================================================================
set -euo pipefail

# arguments
skip_restart=false;
user_name="";
while [[ $# -gt 0 ]]
do
    case "$1" in
        --skip-restart)
            skip_restart=true;
            shift;
            ;;
        --user)
            user_name="$(echo "$2" | xargs)"; # trim user_name
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

# prepare the config-file
readonly CONFIG_FILE="/etc/ssh/sshd_config";
readonly DATE_STRING=$(date +"[%F %T]");
readonly INFO_STRING="# modified ${DATE_STRING} by $0";
cp "${CONFIG_FILE}" "${CONFIG_FILE}.${DATE_STRING}.bak";


# declare properties to set in sshd_config
declare -A properties

# recommendations by: https://community.hetzner.com/tutorials/basic-cloud-config#step-43--harden-ssh
# further recommendations from: ChatGPT
# note: we DO NOT mess with the port numbers. It seems like "security by obscurity".

# disable SSH login as root
properties["PermitRootLogin"]="no";
# disable password authentication altogether
properties["PasswordAuthentication"]="no";
# set LogLevel to 'verbose'
properties["LogLevel"]="VERBOSE";
# set ClientAliveInterval to 300 seconds
properties["ClientAliveInterval"]="300";
# set KbdInteractiveAuthentication to no
properties["KbdInteractiveAuthentication"]="no";
properties["ChallengeResponseAuthentication"]="no";
# limit failed login attempts
properties["MaxAuthTries"]="2";
# disallow forwarding
properties["AllowTcpForwarding"]="no";
properties["X11Forwarding"]="no";
# note: agent forwarding could be useful for development servers!
properties["AllowAgentForwarding"]="no";


# iterate over properties
for key in "${!properties[@]}"; do
    value="${properties[$key]} ${INFO_STRING}";
    grep -qE "^#?${key}" "$CONFIG_FILE" \
        && sed -i "s|^#\?${key}.*|${key} ${value}|g" "$CONFIG_FILE" \
        || echo -e "\n${key} ${value}" >> "$CONFIG_FILE";
done

# set or add allowed user
if [ -n "${user_name}" ]
then
    value="${user_name} ${INFO_STRING}";
    if grep -q "^AllowUsers" "${CONFIG_FILE}"
    then
        if ! grep -q "^AllowUsers.*\b${user_name}\b" "${CONFIG_FILE}"
        then
            # Add user to AllowUsers string
            sudo sed -i "/^AllowUsers/ s/$/ ${value}/" "${CONFIG_FILE}";
        fi
    else
        # Add AllowUsers
        echo -e "\nAllowUsers ${value}" >> "${CONFIG_FILE}";
    fi
fi

# test & restart sshd
if [ "${skip_restart}" = "false" ]
then
    if sshd -t -q; then systemctl restart ssh.service; fi
fi
