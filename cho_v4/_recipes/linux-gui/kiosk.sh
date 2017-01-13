#!/bin/sh
set -e

CHROMIUM_TEMP=/tmp/chromium
rm -Rf ~/.config/chromium/
rm -Rf $CHROMIUM_TEMP
mkdir -p $CHROMIUM_TEMP

/usr/bin/chromium --auto-launch-at-startup \
    --disable \
    --disable-translate \
    --disable-infobars \
    --disable-suggestions-service \
    --disable-save-password-bubble \
    --disk-cache-dir=$CHROMIUM_TEMP/cache/ \
    --user-data-dir=$CHROMIUM_TEMP/user_data/ \
    --start-maximized \
    --kiosk "file:///home/kioskuser/kiosk.html" &
