#!/usr/bin/env bash
##
# AUTHOR zhantewei
##
bin_path=`cd $(dirname $0);pwd`
host_path=`dirname $bin_path`
now_config_path=$host_path/conf/nacos.conf

source $host_path/lib/loadconf.sh
load_config $now_config_path $host_path

if [ ! -d "$target_nacos_path" ];then
  mkdir -p $target_nacos_path
fi

# check volume
volume_exists=`docker volume ls |grep $package_name`
# create volume if not exists
if [ ! "$volume_exists" ];then
  docker volume create -d local --name $package_name
fi

docker_opts="-d -p $nacos_port:$nacos_port"
docker_opts="$docker_opts -v $package_name:$target_nacos_path"
docker_opts="$docker_opts --name nacos-container"
docker run $docker_opts ztwx/nacos-server:0.0.1