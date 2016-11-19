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


_in4__systemctl () {
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
        *start)
            $EXEC systemctl ${SKIP[*]} $command $@; sleep 1;   systemctl ${SKIP[*]} status $@;
        ;;
        *)
            $EXEC systemctl $full_stack
        ;;
    esac
}
alias systemctl=_in4__systemctl
alias ssystemctl='EXEC="sudo";_in4__systemctl'
