#!/bin/bash

set -e

# Define variables
LOG_FILE="$HOME/error_log.txt"  # Monitor this file instead of miner.log
EMAIL_LIST="ibraheem9omar@gmail.com alzweidi@gmail.com"
SMTP_SERVER="smtp.gmail.com"
SMTP_PORT="587"
SMTP_USER="79sends@gmail.com"
SMTP_PASSWORD="rfkfwalbaktmyqwl"

# Check for errors in the error log every minute
while true; do
  echo "[`date`] Checking error_log.txt for errors..."

  # Search for errors in the error log file (can be customized for different errors)
  ERROR_DETAILS=$(grep -i "error\|fail\|exception" "$LOG_FILE")

  if [ ! -z "$ERROR_DETAILS" ]; then
    echo "[`date`] Error found! Sending email notification..."

    # Prepare the email content
    SUBJECT="NockChain Miner Error Detected"
    MESSAGE="An error was detected in your NockChain miner logs.\n\nDetails:\n$ERROR_DETAILS"

    # Send an email using Gmail SMTP
    echo -e "Subject:$SUBJECT\n\n$MESSAGE" | msmtp --host=$SMTP_SERVER --port=$SMTP_PORT --auth=on --user=$SMTP_USER --password=$SMTP_PASSWORD --from=$SMTP_USER --tls=on --tls-starttls --logfile=msmtp.log $EMAIL_LIST

    echo "[`date`] Error notification sent."
  fi

  # Sleep for 60 seconds before checking again
  sleep 60
done
