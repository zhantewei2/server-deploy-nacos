#!/usr/bin/env bash
#
#   auth :zhantewei
#
#
#


function case_env_config(){
    config_path=$1
    env=$2
    if [ ! "$env" ];then
        return 0
    fi


    config_dir="${config_path%/*}"
    config_name="${config_path##*/}"
    config_prefix_name="${config_name%.*}"
    config_extend_name="${config_name##*.}"

    now_config_name="$config_prefix_name.$env.$config_extend_name"


    now_config_path=$config_dir/$now_config_name

    if [ ! -f "$now_config_path" ];then
        echo -e "\033[31m now found config: \033[0m"
        echo "  $now_config_path"
        echo -e "\033[31m progress exit!! \033[0m"
        exit
    fi
    # echo -e "\033[35m load config \033[03m: $now_config_path "
}