#!/bin/bash

# This script creates a local user in a local environment
# You will be prompted to enter the username, person name and a password
# The username, password and host for the account will be displayed

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
    echo 'You need to be root user to execute this script'
    exit 1
fi

# Get the username (login).
read -p 'Enter the username to create: ' USER_NAME

# Get the real name (contents for the description field).
read -p 'Enter the name a and surname of user: ' COMMENT

# Get the password.
read -p 'Enter the password to use for the account: ' PASSWORD

# Create the user with the password.
useradd -c "${COMMENT}" -m ${USER_NAME}

# Check to see if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]
then
    echo 'Ooops there was a problem adding your user, try again'
    exit 1
else
    echo "Your user ${USER_NAME} was added succesfully"
fi

# Set the password.
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
    echo 'Ooops password was not updated :('
    exit 1
else
    echo "Password for user ${USER_NAME} was added successfully"
fi

# Force password change on first login.
passwd -e ${USER_NAME}

# Display the username, password, and the host where the user was created.
echo "New username: ${USER_NAME}"
echo "New password: ${PASSWORD}"
HOST=$(hostname -s)
echo "Host: ${HOST}"

exit 0
