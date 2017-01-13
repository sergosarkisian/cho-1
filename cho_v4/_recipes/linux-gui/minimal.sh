zypper in xf86-input-keyboard xf86-input-mouse  xf86-input-libinput xf86-video-intel xorg-x11-server
zypper in sddm breeze openbox
i3 
chromium
xorg-x11 
xcb

ln -s /usr/lib/systemd/system/sddm.service /etc/systemd/system/display-manager.service
systemctl set-default graphical.target 

[Kiosk]
Encoding=UTF-8
Name=Web Browser
Comment=Use a web browser as your session
Exec=/usr/bin/chromium --auto-launch-at-startup
TryExec=/usr/bin/chromium --auto-launch-at-startup
Icon=google-chrome
