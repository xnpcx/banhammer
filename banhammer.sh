#!/bin/bash
if [ $# -eq 1 ]; then
   CONNLIMIT=$1
else
   echo "Usage: $0 connection_limit"
   exit 1
fi
for IP in $(netstat -ntu | grep ":80" | awk '{print $5}'| cut -d: -f1 | sort | uniq -c | sort -n | grep -v 127.0.0.1 | awk -v connlimit=$CONNLIMIT '{if ($1 > connlimit) print $2;}')
do
    if grep -Fxq "$IP" banned.txt
    then
        echo "$IP already banned"
    else
        echo "banning $IP"
	iptables -A INPUT -s $IP -j DROP
        echo "$IP" >> banned.txt
    fi
done
