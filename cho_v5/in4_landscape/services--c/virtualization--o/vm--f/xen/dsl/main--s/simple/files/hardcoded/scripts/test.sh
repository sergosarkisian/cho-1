declare -A store 
 store[type]=ext
 
 

case "${store[type]}" in
            ext)
            echo "yes"
            ;;
            
            *)
echo "no"
;;
        esac