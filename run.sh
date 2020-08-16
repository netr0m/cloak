#!/usr/bin/env bash
env | grep CLOAK >> /etc/environment &
busybox syslogd &
crond -f &
./usr/bin/run_ovpn.sh
