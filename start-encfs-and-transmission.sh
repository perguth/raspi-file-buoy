#!/bin/bash

# mount encfs
sudo su -c 'encfs --public /media/usbdisk/.torrent /media/usbdisk/torrent' root

# start transmission
sudo service transmission-daemon start
