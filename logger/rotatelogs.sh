#!/bin/bash -e

LOGDIR=${1:-/shared}

find $LOGDIR -type f -iname '*.log' | \
xargs savelog -n -p -l -t

