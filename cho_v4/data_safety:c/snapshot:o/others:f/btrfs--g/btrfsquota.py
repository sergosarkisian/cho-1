#!/usr/bin/env python2

import argparse
import subprocess

parser = argparse.ArgumentParser(
    description='Gives quotas from a BTRFS filesystem in a readable form'
)
parser.add_argument(
    '--unit', metavar='U', type=str,
    default='G',
    help='SI Unit, [B]ytes, K, M, G, T, P',
)
parser.add_argument(
    'mount_point', metavar='PATH', type=str,
    default='/',
    help='BTRFS mount point',
)
sys_args = parser.parse_args()
mount_point = sys_args.mount_point

multiplicator_lookup = ['B', 'K', 'M', 'G', 'T', 'P']

subvolume_data = dict()
cmd = ["btrfs",  "subvolume", "list", mount_point]
for line in subprocess.check_output(cmd).splitlines():
    args = line.strip().split(' ')
    subvolume_data[int(args[1])] = args[-1]

#print("subvol\t\t\t\t\t\t\t\tgroup         total    unshared  total_q  unshared_q")
#print("-" * 100)
cmd = ["btrfs", "qgroup", "show", "--si", "-p", "-c", "-r", "-e",  mount_point]
for line in subprocess.check_output(cmd).splitlines():
    args = [x for x in line.strip().split(' ') if len(x)>0]

    try:
        subvolume_id = args[0].split('/')[-1]
        subvolume_name = subvolume_data[int(subvolume_id)]
    except:
        subvolume_name = "(unknown)"


    try:
        try:
            total =args[1]
            unshared = args[2]  
            total_q =args[3]
            unshared_q = args[4]              
        except ValueError:
            continue
        print("%s  %s  %s  %s %s  %s" % (
            subvolume_name.ljust(40),
            args[0],
            args[1],
            args[2],          
            args[3],
            args[4],              
        ))
    except IndexError:
        pass
