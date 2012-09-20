#!/bin/bash

# CONFIGURATION
FORK_REMOTE='origin'
UPSTREAM_FORK='upstream'
UPSTREAM_BRANCH='master'


# LOGIC

UPSTREAM="$UPSTREAM_FORK:$UPSTREAM_MASTER"

function get_first_char {
	echo "$1" | tr [:upper:] [:lower:] | head -c1
}

function get_reply {
	echo -ne "Remove \033[1m$FORK_REMOTE:$BRANCH\033[0m remote and local branches?" 
	read -p " (y/n/i) "
}


git fetch --multiple $FORK_REMOTE $UPSTREAM_FORK
REMOTE_BRANCHES=`git branch -r | grep $FORK_REMOTE/ | grep -v master | grep -v HEAD| cut -d/ -f2`
for BRANCH in $REMOTE_BRANCHES
do
	get_reply

	while [ "`get_first_char $REPLY`" = 'i' ]
	do
		echo "$UPSTREAM..$FORK_REMOTE/$BRANCH contains:"
		git log $UPSTREAM..$FORK_REMOTE/$BRANCH
		get_reply
	done

	if [ "`get_first_char $REPLY`" = 'y' ]
	then
		git push origin :$BRANCH
		git branch -D $BRANCH
	fi
done
