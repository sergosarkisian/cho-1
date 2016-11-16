#!/bin/bash

zypper  --gpg-auto-import-keys ref
zypper --non-interactive in --force spice-vdagent xen-tools-domU xen-libs
