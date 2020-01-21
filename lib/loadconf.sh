#!/usr/bin/env bash
function load_config(){
    config_path=$1
    source $2/lib/print.sh
    if [ ! -f $1 ]; then
        logInfo "configFile" "not found"
        console "$config_path"
        exit
    fi
    logInfo "read config" "$config_path"
    for line in `cat $config_path`; do
        if [ `echo "$line" |grep ".*=.*"` ];then
            if [ ! `echo "$line"|grep "#"` ];then
                eval "$line"
            fi
        fi
    done
}