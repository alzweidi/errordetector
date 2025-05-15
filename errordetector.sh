#!/bin/bash

# === CONFIGURATION ===
TO_EMAIL="ibraheem9omar@gmail.com"
SUBJECT="✅ NockChain Test Email"
BODY="This is a test email sent from your NockChain server using msmtp."

# === Send email ===
echo -e "Subject: $SUBJECT\n\n$BODY" | msmtp "$TO_EMAIL"

# === Log result ===
echo "Test email sent to $TO_EMAIL"
