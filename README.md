# RaspberryPi BitTorrent, WebTorrent and IPFS server

> Combine a RaspberryPi (a wifi module) and a SSD for an awesome little file buoy :sailboat:

## rasspbian

- [x] get rasbian `LITE`: https://www.raspberrypi.org/downloads/raspbian/
- [x] `sudo raspi-config`
  - [x] activate locale `en.US-UTF8`
  - [x] change hostname
  - [x] set userpassword
- [x] `ssh-copy-id ...`
  - [x] uncomment/set `PasswordAuthentication` to `no` in `sudo nano /etc/ssh/sshd_config`
  - [x] `sudo service ssh restart`
- [x] `sudo visudo` and comment out `pi ALL=(ALL) NOPASSWD: ALL`
- [x] `sudo apt-get update && sudo apt-get upgrade -y`
- [x] `sudo apt-get install screen unattended-upgrades macchanger`
  - [x] `sudo dpkg-reconfigure --priority=low unattended-upgrades`
- [x] `sudo apt-get install fish`
  - [x] change line `pi:x:1000:1000:,,,:/home/pi:/bin/bash` to `pi:x:1000:1000:,,,:/home/pi:/usr/bin/fish`
  - [x] `nano ~/.config/fish/functions/fish_prompt.fish` and fill in:  
  ```sh
function fish_prompt
  set_color 5FAF00
  echo -n (basename $PWD)
  echo -n ' → '
  set_color normal
end
```
- [x] `sudo nano /etc/default/macchanger` and set `ENABLE_ON_POST_UP_DOWN` to `true`.

### set up the wifi module
TODO

## prepare folders && access rights

`sudo nano /etc/group` and change the line `debian-transmission:x:114:` to `debian-transmission:x:114:pi`.

TODO
```sh
# find the uuid of your usbstick or usbdrive
# add to `fstab`
# add folders
# set accessrights for transmission
```

## encfs

## transmission configuration

```sh
sudo apt-get install transmission-daemon
sudo service transmission-daemon stop
sudo nano /etc/transmission-daemon/settings.json
```

set the following values:

- [x] `blocklist-url`: `https://jult.net/bloc.txt.gz`, `blocklist-enabled`: `true`
- [x] `download-dir`: ..., `incomplete-dir`, `incomplete-dir-enabled`: `true`
- [x] `preallocation`: `0`
- [x] `watch-dir`: ..., `watch-dir-enabled`: `true`
- [x] `encryption`: `2`
- [x] `prefetch-enabled`: `false`
- [x] `peer-socket-tos`: `lowcost`
- [x] `download-queue-enabled`: `false`, `queue-stalled-enabled`: `false`
- [x] `rpc-bind-address`: `127.0.0.1`
- [x] `rpc-authentication-required`: `false`
- [x] disable autostart: `sudo systemctl disable transmission-daemon`

```sh
sudo service transmission-daemon start
```

## startscript

```sh
touch start-torrent.sh
chmod +x start-torrent.sh
nano start-torrent.sh
```

and add:

```sh
#!/bin/bash

# mount encfs
sudo su -c 'encfs --public /media/usbdisk/.torrent /media/usbdisk/torrent' root

# start transmission
sudo service transmission-daemon start
```

You need to manually run this after every restart.

## set up pagekite
TODO

## set up webtorrent
TODO

## set up ipfs
TODO
`sudo nano /etc/transmission-daemon/settings.json`: `script-torrent-done-enabled` to hook ipfs?
