#!/bin/bash

# Save this file under: `/opt/etc/transmission/torrent-added.sh`
# Change rights: `chown debian-transmission:debian-transmission /opt/etc/transmission/torrent-added.sh`
# Make it executable: `chmod +x /opt/etc/transmission/torrent-added.sh`
#
# Add following strings to `/opt/etc/transmission/settings.json`:
#
# `script-torrent-added-enabled`: true,
# `script-torrent-added-filename`: `/opt/etc/transmission/torrent-added.sh`,


base_url='https://torrentz.eu'
pattern='announcelist_[0-9]+'

if [ -z "$TR_TORRENT_HASH" ] ; then
  if [[ $* == *-v* ]] ; then
    verbose=true
  fi
  if [ "$verbose" = true ] ; then
    echo "test"
  fi
  
  IFS=$'\n' torrents=($(transmission-remote -l))
  unset torrents[${#arr[@]}-1] # remove last element
  torrents=("${torrents[@]:1}") # remove the first element
  
  for torrent in ${torrents[@]} ; do
    torrent_id=`echo ${torrent} | grep -o -E '[0-9]+' | head -1`
    torrent_hash=`transmission-remote -t ${torrent_id} -i | grep -o 'Hash: .*' | cut -d\  -f2`

    announce_list=`wget -qO - ${base_url}/${torrent_hash} | grep -Eo "${pattern}"`

    if [ -z "$announce_list" ] ; then
      echo $(basename $0) "No additional trackers found for ${torrent_id}"
    else
      for tracker in $(wget -qO - ${base_url}/${announce_list}) ; do
        echo $(basename $0) "Adding ${tracker} to ${torrent_id}, ${torrent_hash}"
        transmission-remote -t ${torrent_hash} -td ${tracker}
      done
    fi
  done

  exit 1
fi

announce_list=`wget -qO - ${base_url}/$TR_TORRENT_HASH | grep -Eo "${pattern}"`

if [ -z "$announce_list" ] ; then
  logger -t $(basename $0) "No additional trackers found for $TR_TORRENT_NAME"
  exit 1
fi

for tracker in $(wget -qO - ${base_url}/${announce_list}) ; do
  logger -t $(basename $0) "Adding ${tracker} to $TR_TORRENT_NAME"
  transmission-remote -t $TR_TORRENT_HASH -td ${tracker}
done
