zypper in xf86-input-keyboard xf86-input-mouse  xf86-input-libinput xf86-video-intel xorg-x11-server 
zypper in sddm breeze openbox plasma5-workspace
xorg-x11-fonts  free-ttf-fonts
i3 
chromium
xorg-x11 
xcb

ln -s /usr/lib/systemd/system/sddm.service /etc/systemd/system/display-manager.service
systemctl set-default graphical.target 

mkdir ~/.config/openbox
cat > autostart ...
