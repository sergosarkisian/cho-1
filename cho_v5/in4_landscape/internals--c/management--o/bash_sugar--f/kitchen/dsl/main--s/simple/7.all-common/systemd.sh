### SYSTEMD ###
 
#CONF
rm -f /etc/systemd/system.conf && ln -s /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/infrastructure--f/systemd/dsl/main--s/simple/files/hardcoded/systemd_defaults.conf /etc/systemd/system.conf
rm -f /etc/systemd/user.conf 	 && ln -s /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/infrastructure--f/systemd/dsl/main--s/simple/files/hardcoded/systemd_defaults.conf /etc/systemd/user.conf
#PROFILE.D
rm -f /etc/profile.d/in4__systemd.bash 	 && ln -s /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/infrastructure--f/systemd/rev5/5_service/profile.d/rev5__internals--c--management--o--infrastructure--f--systemd--g--main--s.aliases.bash /etc/profile.d/in4__systemd.bash 	
###
