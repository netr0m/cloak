#!/bin/bash
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
TUN=$CLOAK_TUN
if [[ -z $TUN ]]; then
	TUN=tun0
fi

iface=$(ip a | grep $TUN)
if [[ $? != 0 ]]; then
	exit 1
else
	exit 0
fi
