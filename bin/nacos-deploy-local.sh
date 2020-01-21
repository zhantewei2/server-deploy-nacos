#!/usr/bin/env bash
#
#   auth :zhantewei
#
#
#
bin_path=$(cd `dirname $0`;pwd)
bin_path=`dirname $bin_path`

env_run=$1
now_config_path=$bin_path/conf/nacos.conf

source $bin_path/lib/loadconf.sh
source $bin_path/lib/case-env-conf.sh
source $bin_path/lib/print.sh
## 部署shell位置
deploy_progress_bin=$bin_path/ansible/roles/nacos-deploy/files/deploy.sh

## 获取当前环境config文件路径
case_env_config $now_config_path $env_run

load_config $now_config_path $bin_path



# echo $deploy_progress_bin
sh $deploy_progress_bin $target_nacos_path $target_nacos_download_address $nacos_port $db_num $db_url0 $db_user $db_password $nacos_cluster $nacos_bind_ip

console 'Install sql statement~'

echo $bin_path/lib/initializeMysql.py
python $bin_path/lib/initializeMysql.py

console 'completed!'