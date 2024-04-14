# New User Check Script

This script monitors the `/etc/passwd` file for any new user accounts added to the system. If a new account is detected, it sends an email alert to notify the system administrator. The script is intended to be run as a cron job to regularly check for new user additions.

## Installation

1. **Clone the Repository:**

    ```bash
    git clone https://github.com/4b415941/NewUsersCheck.git
    ```

2. **Navigate to the Repository Directory:**

    ```bash
    cd new-user-check-script
    ```

3. **Make the Script Executable:**

    ```bash
    chmod +x newusercheck.sh
    ```

4. **Configure Email Addresses:**

    Edit the script to configure the `TO` and `FROM` email addresses:

    ```bash
    TO="<to@domain.com>"
    FROM="<from@domain.com>"
    ```

5. **Add the Script to Cron Jobs:**

    Open the cron jobs configuration:

    ```bash
    crontab -e */5 * * * * /bin/bash /root/check/newusercheck.sh 1>/dev/null 2>/dev/null
    ```

    Add the following line to run the script every 5 minutes:

    ```cron
    */5 * * * * /bin/bash /path/to/newusercheck.sh 1>/dev/null 2>/dev/null
    ```

## Usage

The script will run automatically as a cron job every 5 minutes. It will check for new user accounts in the `/etc/passwd` file and send an email alert if any new accounts are detected.

## Configuration

- **TO**: Email address where alerts will be sent.
- **FROM**: Email address from which alerts are sent.
- **USERLIST**: Path to store the previous user list.
- **NEWUSERLIST**: Path for the temporary new user list.
- **PASSWDFILE**: Path to the `/etc/passwd` file.
