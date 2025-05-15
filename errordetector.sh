#!/bin/bash

set -e

# Define variables
LOG_FILE="/root/nockchain/miner/logs/miner.log"
ERROR_LOG="$HOME/nockchain/error_log.txt"
EMAIL_LIST="ibraheem9omar@gmail.com"
SMTP_SERVER="smtp.gmail.com"
SMTP_PORT="587"
SMTP_USER="79sends@gmail.com"
SMTP_PASSWORD="rfkfwalbaktmyqwl"

# Create the error log file if it does not exist
if [ ! -f "$ERROR_LOG" ]; then
  touch "$ERROR_LOG"
  echo "[`date`] Created error log file at $ERROR_LOG"
fi

# Check for errors in the miner log every minute
while true; do
  echo "[`date`] Checking logs for errors..."
  # Search for errors in the log file (can be customized for different errors)
  grep -i "error\|fail\|exception" "$LOG_FILE" > "$ERROR_LOG"

  if [ -s "$ERROR_LOG" ]; then
    echo "[`date`] Error found! Sending email notification..."

    # Prepare the email content
    ERROR_DETAILS=$(cat "$ERROR_LOG")
    SUBJECT="NockChain Miner Error Detected"
    MESSAGE="An error was detected in your NockChain miner logs.\n\nDetails:\n$ERROR_DETAILS"

    # Send an email using Gmail SMTP
    echo -e "Subject:$SUBJECT\n\n$MESSAGE" | msmtp --host=$SMTP_SERVER --port=$SMTP_PORT --auth=on --user=$SMTP_USER --password=$SMTP_PASSWORD --from=$SMTP_USER --tls=on --tls-starttls --logfile=msmtp.log $EMAIL_LIST

    echo "[`date`] Error notification sent."
  fi

  # Sleep for 60 seconds before checking again
  sleep 60
done
