#!/bin/bash

# This script sends an email alert if a new account is added to the /etc/passwd file.
# The CRONJOB below runs this script every 5 minutes.

# */5 * * * * /bin/bash /root/check/newusercheck.sh 1>/dev/null 2>/dev/null


HOSTNAME=$(hostname) # Stores the system hostname
TO="mail_address" # Email address where alerts will be sent
FROM="another_mail_address"	# Email address from which alerts are sent
USERLIST="/root/check/.userlist.lst" # File path to store the previous user list
NEWUSERLIST="/root/check/.users.txt" # File path for the temporary new user list. This temporary file must be in the directory before running the script
PASSWDFILE="/etc/passwd" # Path to the /etc/passwd file

COMPARE=0 #Flag to compare user lists

trap "/bin/rm -rf --preserve-root -- $NEWUSERLIST" 0
# Ensures temporary file deletion when script exits

# Checks for the existence and non-emptiness of the previous user list
if [ -s "$USERLIST" ] ; then
	/usr/bin/printf "Database is being checked...\n"
	LASTCHECK="$(/bin/cat $USERLIST)"
    COMPARE=1 # Indicates comparison will be performed
fi

# Obtains the current user list
/usr/bin/printf "Getting current user list\n"
/bin/cat $PASSWDFILE | /usr/bin/cut -d: -f1 > $NEWUSERLIST

CURRENT="$(/bin/cat $NEWUSERLIST)"

# Compares user lists if a previous list exists
if [ $COMPARE -eq 1 ] ; then
    if [ "$CURRENT" != "$LASTCHECK" ] ; then
		/usr/bin/printf "WARNING: password file has changed\n"
		# Lists newly added and removed users
		/usr/bin/diff $USERLIST $NEWUSERLIST | /bin/grep '^[<>]' | /bin/sed 's/</Removed: /;s/>/Added:/'

	/usr/bin/printf "Sending email alert...\n"
		# Sends an email alert
		/usr/bin/mail -r $FROM -A $NEWUSERLIST -s "WARNING: New Account Created on $HOSTNAME" $TO <<< "You are receiving this email because a new user account has been created on $HOSTNAME."

	/usr/bin/printf "The user list has been updated!\n"
	/bin/mv $NEWUSERLIST $USERLIST
	else
		/usr/bin/printf "No new users have been created since the last check\n"
	fi
else
	usr/bin/printf "Instant current user database is being created...\n"
	/bin/mv $NEWUSERLIST $USERLIST # Creates the initial user list
fi

/bin/chmod 600 $USERLIST # Sets permissions for the user list file for security
exit 0 
