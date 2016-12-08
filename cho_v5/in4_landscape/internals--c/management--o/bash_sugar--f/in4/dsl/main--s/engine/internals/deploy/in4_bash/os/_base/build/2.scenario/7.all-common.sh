#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

#in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "3_recipe/in4_shell" "in4.recipe.sh"
#in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "3_recipe/in4_shell" "bash.recipe.sh"
in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "3_recipe/in4_shell" "drbd9.recipe.sh"
in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "3_recipe/in4_shell" "exim.recipe.sh"
#in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "3_recipe/in4_shell" "nss.recipe.sh"
#in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "3_recipe/in4_shell" "profile.d.recipe.sh"
#in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "3_recipe/in4_shell" "rsyslog.recipe.sh"
#in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "3_recipe/in4_shell" "sshd.recipe.sh"
#in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "3_recipe/in4_shell" "sssd.recipe.sh"
in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "3_recipe/in4_shell" "sudo.recipe.sh"
#in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "3_recipe/in4_shell" "swf2.recipe.sh"
in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "3_recipe/in4_shell" "zypper.recipe.sh"
#in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "3_recipe/in4_shell" "sysctl.recipe.sh"
#in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "3_recipe/in4_shell" "systemd.recipe.sh"
#in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "3_recipe/in4_shell" "wtf.recipe.sh"

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
