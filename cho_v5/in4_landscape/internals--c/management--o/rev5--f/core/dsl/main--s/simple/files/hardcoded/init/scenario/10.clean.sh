echo -e "\n\n######## ######## START -  scenario - ${0##*/} ######## ########\n\n"

### RM ALL LOGS & TRACES ###
rm -f /var/log/*/*
rm -f /var/log/*.log
rm -f /root/.bash_history
rm -rf /tmp/*
history -c
exit 

echo -e "\n\n######## ######## STOP -  scenario - ${0##*/} ######## ########\n\n"
