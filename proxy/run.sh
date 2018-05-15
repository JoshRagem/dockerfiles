#!/bin/bash -e
proxydns.sh

dnsmasq
exec tinyproxy -c /etc/tinyproxy/tinyproxy.conf -d

