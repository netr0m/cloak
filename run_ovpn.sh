#!/usr/bin/env bash
killall openvpn
openvpn --config /vpn/profile.ovpn --auth-user-pass /vpn/vpn.auth --auth-nocache
