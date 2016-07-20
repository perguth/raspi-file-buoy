#!/bin/bash

# place this file under `/root/keep-wifi-up.sh`
# make executable: `chmod +x /root/keep-wifi-up.sh`
# open crontab `crontab -e` and add `* * * * * /usr/bin/sudo /root/keep-wifi-up.sh`

if ifconfig wlan0 | grep -q "inet addr:" ; then
  exit 1
fi
ifup --force wlan0
