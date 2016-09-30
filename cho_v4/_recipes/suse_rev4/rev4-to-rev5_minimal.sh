zypper ar -cf -n "rev5" http://download.opensuse.org/repositories/home:/conecenter:/suse:/rev5/openSUSE_13.2/ "rev5"

zypper --gpg-auto-import-keys up *grub*
 #yast bootloader -> grub2
cp /media/sysdata/rev5/techpool/ontology/linux_sys/grub2/etc_default_grub-vm /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

zypper up xen-libs xen-tools-domU
zypper in --force xen-kmp-default drbd-kmp-default kernel-default


zypper --non-interactive rm *bacula*
zypper --non-interactive in bareos-client
zypper  up *rsyslog* *sss* *systemd* openssh *sudo* rpm *zypp* *pam* *erlang* *bash* atop stunnel *bareos* *systemd* liblognorm2 ocfs2-* *zypp*

sed -i "s/default.*/default\ 1/" /boot/grub/menu.lst
sed -i "s/set\ default.*/set\ default=\"hvm\"/" /boot/grub2/grub.cfg
