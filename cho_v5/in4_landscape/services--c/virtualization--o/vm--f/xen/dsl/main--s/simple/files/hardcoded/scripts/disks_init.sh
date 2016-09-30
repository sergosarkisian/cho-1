#!/bin/bash

fallocate -l10g ./logs.raw
mkfs.ext4 -L "logs" ./logs.raw

fallocate -l1g ./swap.raw
mkswap -L "swap" ./swap.raw 

