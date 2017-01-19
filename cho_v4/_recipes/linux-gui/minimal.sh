##DESKTOP
zypper ar -cf -n non-oss http://download.opensuse.org/distribution/leap/42.2/repo/non-oss/ non-oss
zypper ar -cf http://download.opensuse.org/update/leap/42.2/non-oss/openSUSE:Leap:42.2:NonFree:Update.repo

zypper ar -cf -n packman http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_42.2/ packman
zypper ar -cf http://download.opensuse.org/repositories/multimedia:/apps/openSUSE_Leap_42.2 multimedia:apps::leap42.2
zypper ar -cf http://download.opensuse.org/repositories/multimedia:/libs/openSUSE_Leap_42.2 multimedia:libs::leap42.2

zypper ar -cf http://download.opensuse.org/repositories/LibreOffice:/5.2/openSUSE_Leap_42.2/LibreOffice:5.2.repo
zypper ar -cf http://download.opensuse.org/repositories/network:/chromium/openSUSE_Leap_42.2 network:chromium::leap42.2
zypper ar -cf http://download.opensuse.org/repositories/mozilla/openSUSE_Leap_42.2 mozilla::leap42.2

zypper ar -cf http://download.opensuse.org/repositories/security:/chipcard/openSUSE_Leap_42.2 security:chipcard::leap42.2
zypper ar -cf http://download.opensuse.org/repositories/Archiving/openSUSE_Leap_42.2 archiving::leap42.2
zypper ar -cf http://download.opensuse.org/repositories/devel:/tools:/scm:/svn/openSUSE_Leap_42.2 tools:scm:svn::leap42.2

zypper in chromium kdesvn kontact5 wireshark kate kdiff3 chromium-desktop-kde flash-player vlc vlc-codecs ffmpeg lame esteidcerts esteidfirefoxplugin esteidpkcs11loader estonianidcard libdigidoc libdigidocpp qdigidoc qesteidutil estonianidcard powertop powerstat remmina rdesktop remmina-plugin-rdp remmina-plugin-vnc libasound2-32bit libXv1-32bit libXss1-32bit libqt4-x11-32bit filezilla MozillaFirefox kwalletmanager5 libsvn_auth_kwallet-1-0  pgadmin3 kmail5 kcalc kopete okular ktorrent baloo5 kaddressbook5 gwenview5 spice-client

####


########
zypper ar -cf http://download.opensuse.org/repositories/KDE:/Qt5/openSUSE_Leap_42.2/KDE:Qt5.repo
zypper ar -cf http://download.opensuse.org/repositories/KDE:/Frameworks5/openSUSE_Leap_42.2/KDE:Frameworks5.repo
zypper ar -cf http://download.opensuse.org/repositories/KDE:/Applications/openSUSE_Leap_42.2/KDE:Applications.repo
zypper ar -cf http://download.opensuse.org/repositories/KDE:/Extra/openSUSE_Leap_42.2/KDE:Extra.repo

zypper in xf86-input-keyboard xf86-input-mouse  xf86-input-libinput xf86-video-intel xorg-x11-server xorg-x11
zypper in sddm breeze openbox plasma5-workspace chromium
zypper in xorg-x11-fonts  free-ttf-fonts
###
----
i3 
xcb
---

ln -s /usr/lib/systemd/system/sddm.service /etc/systemd/system/display-manager.service
systemctl set-default graphical.target 

mkdir ~/.config/openbox
cat > autostart ...
