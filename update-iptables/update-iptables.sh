#!/usr/bin/env bash

iptables -t nat -A OUTPUT -p tcp \
-d 169.254.169.254 --dport 80 \
-j DNAT --to-destination ${MOCK_METADATA_IP}:${MOCK_METADATA_PORT} || return 1

echo "IPTables updated. Here is what it looks like."
iptables-legacy -t nat -S
