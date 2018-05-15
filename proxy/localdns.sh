#!/bin/bash
match="$(head -n 1 /etc/resolv.conf)"
insert='nameserver 127.0.0.1'
file='./resolv.conf'
cp /etc/resolv.conf ./
sed -i "s/$match/$match\n$insert/" $file
cp ./resolv.conf /etc/resolv.conf
