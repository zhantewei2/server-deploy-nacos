#!/usr/bin/env bash
##
# AUTHOR zhantewei
##
bin_path=`cd $(dirname $0);pwd`
host_path=`dirname $bin_path`
now_config_path=$host_path/conf/nacos.conf

source $host_path/lib/loadconf.sh
load_config $now_config_path $host_path

cd $host_path

docker build --build-arg nacos_port=$nacos_port --build-arg nacos_path=$target_nacos_path -f docker/Dockerfile -t ztwx/nacos-server:0.0.1 .