#! /bin/bash
# Add iptables rule to NAT port 80 traffic to docker0:8118(Privoxy port). 

set -e

DOCKER0_IP=$(ifconfig docker0 | sed -En '\''s/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'\'')

# IPtables rule
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 80 -j DNAT --to $DOCKER0_IP:8118
