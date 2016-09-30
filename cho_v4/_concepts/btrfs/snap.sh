#!/bin/bash
/usr/sbin/btrfs subvolume snapshot -r /media/storage/$1 /media/storage/snapshots/$1/`date +%d.%m.%y_%H:%M:%S`

