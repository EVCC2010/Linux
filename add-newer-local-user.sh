#!/bin/bash

# This script creates a new user on the local system
# You must supply a username as an argument to the script
# Optionally, you can also provide a comment for the accoun as an argument
# A password will be automatically generated for the account
# The username, password, and host for the account will be displayed

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then 
    echo "You are not root user" >&2
    exit 1
fi

# If the user doesn't supply at least one argument, then give them help.
NUMBER_OF_PARAMETERS="${#}"

if [[ "${NUMBER_OF_PARAMETERS}" -lt 1 ]]
then 
    echo "To execute this script you need to add at least one argument: USER_NAME [ARGUMENT]..." >&2
    exit 1 
fi

# The first parameter is the user name.
USER_NAME="${1}"

# The rest of the parameters are for the account comments.
shift
COMMENTS="${@}"

# Generate a password.
PASSWORD=$(date +%s%N | sha256sum | head -c3)

# Create the user with the password.
useradd -c "${COMMENT}" -m ${USER_NAME} &> /dev/null

# Check to see if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]
then 
    echo "The account could not be created" >&2
    exit 1
fi

# Set the password.
echo ${PASSWORD} | passwd --stdin ${USER_NAME} &> /dev/null

# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
    echo "Password was not set to the account" >&2
    exit 1
fi

# Force password change on first login.
passwd -e ${USER_NAME} &> /dev/null

# Display the username, password, and the host where the user was created.


echo "username: ${USER_NAME}"
echo "password: ${PASSWORD}"
echo "host: ${HOSTNAME}"

exit 0