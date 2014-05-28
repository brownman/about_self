reset
#       [ ! -f $dir_self/env.cfg ] && { cp $dir_self/.env.example.cfg $dir_self/env.cfg;  }
#    source $dir_self/env.cfg
#echo "[language I want to learn]"
#cat -n $dir_self/languages.txt
#echo
####################################catch the fucken bug#######################/
[ -f /tmp/err ] && { /bin/rm /tmp/err; }
[ -f /tmp/env ] && { /bin/rm /tmp/env; }
env> /tmp/env
exec 2>/tmp/err
trap trap_err ERR
########################################################################/
source CFG/helpers.cfg
source CFG/pv1.cfg
test(){
    ########################## Test Requirements: 
    print_func
    local result=0
    ########################## install dependencies 
    list=`pull depend`
    for item in $list;do
        cmd="dpkg -S $item"
        eval "$cmd" 1>/dev/null && { echo "[V] package exist: $item"; } || { echo >&2 "[X] sudo apt-get install $item" ;result=1; }
    done
    ########################### test if gmail-notify is running: 
    #        cmd=`pull check`
    #       str=`eval "$cmd"`
    #       [ -n "$str" ] && { echo "[V] gmail-notify is running"; } || { echo >&2 "[X] please run gmail-notify" ;result=1; } 

    ########################### test if the user update the default configurations 
    [ -n "$user" ] && { echo "[V] user is set: $user"; } || { echo >&2 "[X] please update your gmail settings which located in this file" ;result=1; }
    return $result
}

steps(){
    info_bug_report

    info_title
    ensure_user
    installing_symlink    
    str_res=$( eval test )
    res=$?
    if [ $res -eq 0 ];then
        #            info_conf
        installing_hotkey
    else
        echo
        print_color 32 "[INSTRUCTIONS]"
        notify-send "Error" "do_for_others_first"
        cat /tmp/err 
        #| pv -qL 10
    fi
}

steps
echo
echo


    echo
print_color 35 "[fortune]"
# echo   (    cowsay "$( fortune )" )
echo  "`fortune`"


echo The End
set +u
set +e

