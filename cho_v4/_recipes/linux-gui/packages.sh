/sbin/yast security level roaming

####  GUI - minimal  ##### 
zypper ar -cf http://download.opensuse.org/repositories/KDE:/Qt5/openSUSE_Leap_42.2/KDE:Qt5.repo
zypper ar -cf http://download.opensuse.org/repositories/KDE:/Frameworks5/openSUSE_Leap_42.2/KDE:Frameworks5.repo


zypper in xf86-input-keyboard xf86-input-mouse  xf86-input-libinput xf86-video-intel xorg-x11-server xorg-x11
zypper in sddm breeze openbox plasma5-workspace chromium plasma5-session 
####       #####



####  DESKTOP DEV - minimal  ##### 
# + gui-minimal + 
zypper ar -cf -n non-oss http://download.opensuse.org/distribution/leap/42.2/repo/non-oss/ non-oss
zypper ar -cf http://download.opensuse.org/update/leap/42.2/non-oss/openSUSE:Leap:42.2:NonFree:Update.repo
zypper ar -cf http://download.opensuse.org/repositories/network:/chromium/openSUSE_Leap_42.2 network:chromium::leap42.2
zypper ar -cf http://download.opensuse.org/repositories/mozilla/openSUSE_Leap_42.2 mozilla::leap42.2
zypper ar -cf -n packman http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_42.2/ packman

zypper in xorg-x11-fonts  free-ttf-fonts adobe-sourcecodepro-fonts adobe-sourcehansans-fonts adobe-sourcesanspro-fonts adobe-sourceserifpro-fonts dejavu-fonts yast2-fonts

zypper in cryptsetup yast2-network iw polkit-default-privs  termcap terminfo xcb
zypper in MozillaFirefox remmina remmina-plugin-rdp remmina-plugin-vnc remmina-plugin-xdmcp remmina-plugin-spice rdesktop spice-client wireshark filezilla samba-client pulseaudio pulseaudio-utils
zypper in esteidcerts esteidfirefoxplugin esteidpkcs11loader estonianidcard libdigidoc libdigidocpp qdigidoc qesteidutil estonianidcard
####       #####




####  KDE  ##### 
# + gui-minimal + 
zypper ar -cf http://download.opensuse.org/repositories/KDE:/Applications/openSUSE_Leap_42.2/KDE:Applications.repo
zypper ar -cf http://download.opensuse.org/repositories/KDE:/Extra/openSUSE_Leap_42.2/KDE:Extra.repo

systemsettings5 kf5-filesystem kcm_sddm baloo5 dolphin konsole plasma5-addons kwalletmanager5 libsvn_auth_kwallet-1-0 
spectacle okular kmail5 kcalc kopete kaddressbook5 gwenview5 kate kwrite kontact5 kdesvn kdiff3 ksshaskpass5
discover-plasmoid plasma-nm5-l2tp plasma-nm5-openconnect plasma-nm5-openvpn plasma-nm5-ssh plasma-nm5-pptp plasma-nm5-vpnc plasma-theme-oxygen bplasma5-mediacenter plasma5-pa plasmoid-activitymanager


####       #####


####   DESKTOP - full    #####
# + gui-minimal + 
# + DESKTOP DEV minimal + 
zypper ar -cf http://download.opensuse.org/repositories/multimedia:/apps/openSUSE_Leap_42.2 multimedia:apps::leap42.2
zypper ar -cf http://download.opensuse.org/repositories/multimedia:/libs/openSUSE_Leap_42.2 multimedia:libs::leap42.2
zypper ar -cf http://download.opensuse.org/repositories/LibreOffice:/5.2/openSUSE_Leap_42.2/LibreOffice:5.2.repo


zypper ar -cf http://download.opensuse.org/repositories/security:/chipcard/openSUSE_Leap_42.2 security:chipcard::leap42.2

zypper in chromium-desktop-kde dragonplayer flash-player vlc vlc-codecs ffmpeg lame 
cyrus-sasl cyrus-sasl-crammd5 cyrus-sasl-plaincyrus-sasl-digestmd5 cyrus-sasl-gssapi 
zypper in libasound2-32bit libXv1-32bit libXss1-32bit libqt4-x11-32bit libQtWebKit4-32bit
pulseaudio-utils pulseaudio-module-x11 pulseaudio-module-jack pulseaudio-equalizer pulseaudio-bash-completion  alsa alsa-plugins-pulse pavucontrol pavumeter pavucontrol-qt phonon4qt5-backend-vlc

zypper in powertop powerstat pgadmin3 ntfs-3g fuse cups 
zypper in plymouth plymouth-branding-openSUSE plymouth-dracut plymouth-theme-breeze
 libreoffice libreoffice-writer libreoffice-math libreoffice-l10n-ru libreoffice-impress libreoffice-icon-theme-breeze libreoffice-calc libreoffice-base libreoffice-kde4 libreoffice-draw libreoffice-writer-extensions libreoffice-icon-theme-oxygen
ark wireshark-ui-qt
akonadi-calendar 
#ktorrent

####       #####


#####
#### SSD - tmpfs + tunes ####
echo 'ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="deadline"' > /etc/udev/rules.d/60-sched.rules
echo 'ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="cfq"
' >> /etc/udev/rules.d/60-sched.rules

systemctl disable systemd-readahead-collect.service
systemctl disable systemd-readahead-replay.service
sed -i "s/vm\.swappiness.*/vm.swappiness=1/" /etc/sysctl.d/memory.conf


# crypt - setup
cryptsetup luksFormat /dev/sda5
#mkfs.btrfs -L "storage" /dev/dm-0
#/etc/crypttab

#btrfs - subvolumes
###

## yast -> fonts => "force aliasing"


----
i3 
xcb
---

ln -s /usr/lib/systemd/system/sddm.service /etc/systemd/system/display-manager.service
systemctl set-default graphical.target 

mkdir ~/.config/openbox
cat > autostart ...


cp /media/sysdata/in4/cho/cho_v4/_recipes/linux-gui/conf/displaymanager /etc/sysconfig/displaymanager



