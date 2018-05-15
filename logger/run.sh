#!/bin/bash -e

mkdir -p /shared/
exec td-agent-bit -c /etc/td-agent-bit/td-agent-bit.conf

