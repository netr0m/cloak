#!/bin/bash
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
TUN=$CLOAK_TUN
URL='https://ipinfo.io/country'
CC=$CLOAK_COUNTRY

function log () {
	printf "$(date) | $1\n" >> /vpn/healer.log
}

function restart_ovpn () {
	log "healer.restart()"
	log ".restart() => restarting openvpn"
	/usr/bin/run_ovpn.sh &
}

function check_iface () {
	log "healer.interface(tun:${TUN})"
	iface=$(ip a | grep $TUN)
	if [[ $? != 0 ]]; then
		log ".interface() ${TUN} was not found"
		log ".interface() => restarting"
		restart_ovpn
		return 1
	else
		log ".interface() OK"
		return 0
	fi
}

function check_country () {
	log "healer.country(country:${CC})"
	actual=$(curl -s $URL)
	log ".country() => country=${actual}"
	if [[ $? != 0 ]]; then
		log ".country() => network error"
		restart_ovpn
	elif [[ $actual != $CC ]]; then
		log ".country() => actual country is not same as expected"
		restart_ovpn
	else
		log ".country() => OK"
	fi
}

function main () {
	log "=========="
	log "healer(tun:${TUN},country:${CC}) => running..."
	check_iface
	if [[ $? == 0 ]]; then
		check_country
	fi
}

main
