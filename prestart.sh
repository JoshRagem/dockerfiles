#!/bin/bash -e

if [ $$ -eq 1 ]; then
	echo "please use proper init system"
	exit 1
fi

monit

exec /bin/run.sh "$@"

