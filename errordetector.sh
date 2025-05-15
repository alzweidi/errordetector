#!/bin/bash

set -e

# === CONFIGURATION ===
LOG_FILE="$HOME/nockchain/error_log.txt"
EMAIL_LIST="ibraheem9omar@gmail.com"
STATE_FILE="$HOME/.last_error_hash"
SMTP_CONFIG="$HOME/.msmtprc"

# === Ensure msmtp config exists ===
if [ ! -f "$SMTP_CONFIG" ]; then
  echo "❌ SMTP config ($SMTP_CONFIG) not found. Exiting."
  exit 1
fi

# === Main Loop ===
while true; do
  echo "[`date`] Checking error_log.txt for new errors..."

  # Get error lines
  ERROR_LINES=$(grep -i "error\|fail\|exception" "$LOG_FILE" || true)

  if [ -n "$ERROR_LINES" ]; then
    # Create a hash of current errors
    ERROR_HASH=$(echo "$ERROR_LINES" | md5sum | awk '{ print $1 }')

    # Compare to last sent hash
    if [ "$ERROR_HASH" != "$(cat $STATE_FILE 2>/dev/null)" ]; then
      echo "[`date`] New error(s) found. Preparing to send email..."

      # === Add basic suggestions ===
      SUGGESTIONS=""
      if echo "$ERROR_LINES" | grep -qi "connection refused"; then
        SUGGESTIONS+="\nSuggestion: Check if the miner node crashed or if the port is blocked."
      fi
      if echo "$ERROR_LINES" | grep -qi "no such file"; then
        SUGGESTIONS+="\nSuggestion: A file or path may be missing. Check installation directories."
      fi
      if echo "$ERROR_LINES" | grep -qi "panic"; then
        SUGGESTIONS+="\nSuggestion: Likely a code-level issue. Restart the miner and monitor the logs."
      fi

      # === Prepare email ===
      SUBJECT="🚨 NockChain Miner Error Detected"
      MESSAGE="An error was detected in your NockChain logs.\n\nDetails:\n$ERROR_LINES\n\n---$SUGGESTIONS"

      echo -e "Subject:$SUBJECT\n\n$MESSAGE" | msmtp -a default $EMAIL_LIST

      echo "$ERROR_HASH" > "$STATE_FILE"
      echo "[`date`] ✅ Email sent successfully."
    else
      echo "[`date`] No new errors found."
    fi
  else
    echo "[`date`] No errors in log."
  fi

  sleep 60
done
