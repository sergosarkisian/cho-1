#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

in4func_run "internals--c--management--o--kitchen--f--in4--g--main--s" "3_recipe/in4_shell" "bash.recipe.sh"
in4func_run "internals--c--management--o--kitchen--f--in4--g--main--s" "3_recipe/in4_shell" "exim.recipe.sh"
in4func_run "internals--c--management--o--kitchen--f--in4--g--main--s" "3_recipe/in4_shell" "nss.recipe.sh"
in4func_run "internals--c--management--o--kitchen--f--in4--g--main--s" "3_recipe/in4_shell" "rsyslog.recipe.sh"
in4func_run "internals--c--management--o--kitchen--f--in4--g--main--s" "3_recipe/in4_shell" "sshd.recipe.sh"
in4func_run "internals--c--management--o--kitchen--f--in4--g--main--s" "3_recipe/in4_shell" "sudo.recipe.sh"
in4func_run "internals--c--management--o--kitchen--f--in4--g--main--s" "3_recipe/in4_shell" "swf2.recipe.sh"
in4func_run "internals--c--management--o--kitchen--f--in4--g--main--s" "3_recipe/in4_shell" "zypper.recipe.sh"
in4func_run "internals--c--management--o--kitchen--f--in4--g--main--s" "3_recipe/in4_shell" "wtf.recipe.sh"

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
