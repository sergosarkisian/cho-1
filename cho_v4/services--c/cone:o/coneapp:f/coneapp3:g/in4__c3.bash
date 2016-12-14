########    #######    ########    #######    ########    ########
##     / / / /    License    \ \ \ \ 
##    Copyleft culture, Copyright (C) is prohibited here
##    This work is licensed under a CC BY-SA 4.0
##    Creative Commons Attribution-ShareAlike 4.0 License
##    Refer to the http://creativecommons.org/licenses/by-sa/4.0/
########    #######    ########    #######    ########    ########
##    / / / /    Code Climate    \ \ \ \ 
##    Language = bash DSL, profiles
##    Indent = space;    4 chars;
########    #######    ########    #######    ########    ########


_c3 () {
    full_stack=$@
    SKIP=()


    for i in "$@"; do
        if [[ $i =~ "--" ]]; then
            SKIP+=("${i#*=}")
            shift
            PARAMS=$@
        else
            command=$i
            shift
            break
        fi
    done

        case $command in
        status)
            systemctl --user $command in4__cone_c3_i@$@
        ;;  
        start|restart|stop)
            systemctl --user $command in4__cone_c3_i@$@ ; sleep 1; systemctl --user status in4__cone_c3_i@$@
        ;;          
        *)
             systemctl --user status in4__cone_c3_i@*
        ;;
    esac
}
alias c3=_c3


