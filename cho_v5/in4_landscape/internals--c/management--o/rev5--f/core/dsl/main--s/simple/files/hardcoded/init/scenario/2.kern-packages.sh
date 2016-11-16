#!/bin/bash

zypper  --gpg-auto-import-keys ref
zypper --non-interactive in --force kernel-default grub2
