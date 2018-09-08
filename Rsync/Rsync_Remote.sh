#!/bin/bash
# Simple rsync "driver" script to back up customers data using SSH/RSYNC
# Written by Erik Soroka, e-mail erik@erikimh.com or ext 834 for questions.

#Establish hostname
HOST="`hostname`"

# Destination host machine name
DEST="DESTINATION.HOST.COM"

# User that rsync will connect as
USER="USERNAME"

# Directory to copy from on the source machine.
BACKDIR="/home/yourdirectory"

# Directory to copy to on the destination machine.
DESTDIR="$HOST/"

# i.e., *~, *.bak, etc.  One "pattern" per line - You must create this file.
EXCLUDES=/etc/bkpexcludes

# Options.
# -n Don't do any copying, but display what rsync *would* copy. For testing.
# -a Archive. Mainly propogate file permissions, ownership, timestamp, etc.
# -u Update. Don't copy file if file on destination is newer.
# -v Verbose -vv More verbose. -vvv Even more verbose.
# See man rsync for other options.

# Does copy, but still gives a verbose display of what it is doing
OPTS="-v -u -a --chmod=u+rwx --delete --bwlimit=250 --rsh=ssh --exclude-from=$EXCLUDES --stats"

# May be needed if run by cron?
export PATH=$PATH:/bin:/usr/bin:/usr/local/bin

# Only run rsync if $DEST host responds.
VAR=`ping -s 1 -c 1 $DEST > /dev/null; echo $?`
if [ $VAR -eq 0 ]; then
    rsync $OPTS $BACKDIR $USER@$DEST:$DESTDIR
else
    echo "Cannot connect to $DEST."
fi

