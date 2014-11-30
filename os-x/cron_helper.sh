#!/bin/bash

SCRIPT='./backup_smb.sh'
RETRY_DELAY=1800
EXIT_DELAY=84601

# there should really be a check here if we're running already.
# damn cron

START=$(date +"%s")
CURR=$(date +"%s")
DIFF=$(($CURR-$START))

# we will run a maximum of one day
while [ $DIFF -lt $EXIT_DELAY ]; do
    # run the script
    $SCRIPT
    # get return value of that script
    RETURN=$?
    if [ $RETURN -eq 0 ]; then
        # the script returned 0, the $whatever started. We can finish here
        exit 0
    fi
    # if we're still running, let's go to sleep 
    sleep $RETRY_DELAY
    # calculate diff for loop check
    CURR=$(date +"%s")
    DIFF=$(($CURR-$START))
done
