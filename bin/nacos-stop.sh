bin_path=$(cd `dirname $0`;pwd)
bin_path=`dirname $bin_path`
now_config_path=$bin_path/conf/nacos.conf

source $bin_path/lib/loadconf.sh
source $bin_path/lib/case-env-conf.sh


case_env_config $now_config_path $1
load_config $now_config_path $bin_path

sh $target_nacos_path/bin/shutdown.sh