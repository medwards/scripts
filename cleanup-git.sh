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
	if [ -n "$1" ]
	then
		READ_REMOTE="$1:"
		REMOTE_INFO=" remote and local branches"
	else
		READ_REMOTE=
		REMOTE_INFO=" local branch"
	fi

	echo -ne "Remove \033[1m$READ_REMOTE$BRANCH\033[0m$REMOTE_INFO?"
	read -p " (y/n/i) "
}


git fetch --multiple $FORK_REMOTE $UPSTREAM_FORK
REMOTE_BRANCHES=`git branch -r | grep $FORK_REMOTE/ | grep -v master | grep -v HEAD| cut -d/ -f2`
for BRANCH in $REMOTE_BRANCHES
do
	get_reply $FORK_REMOTE

	while [ "`get_first_char $REPLY`" = 'i' ]
	do
		echo "$UPSTREAM..$FORK_REMOTE/$BRANCH contains:"
		git log $UPSTREAM..$FORK_REMOTE/$BRANCH
		get_reply $FORK_REMOTE
	done

	if [ "`get_first_char $REPLY`" = 'y' ]
	then
		git push origin :$BRANCH
		git branch -D $BRANCH
	fi
done

if [ "$1" != '--local' ]
then
	exit
fi

LOCAL_BRANCHES=`git branch | grep -v master | grep -v HEAD| grep -v '(no branch)' | tr -d [:blank:] | tr -d '*'`
for BRANCH in $LOCAL_BRANCHES
do
	if [[ $REMOTE_BRANCHES =~ $BRANCH ]]
	then
		# skip branches that we've already made decisions about
		continue
	fi

	get_reply

	while [ "`get_first_char $REPLY`" = 'i' ]
	do
		echo "$UPSTREAM..$BRANCH contains:"
		git log $UPSTREAM..$BRANCH
		get_reply
	done

	if [ "`get_first_char $REPLY`" = 'y' ]
	then
		git branch -D $BRANCH
	fi
done
