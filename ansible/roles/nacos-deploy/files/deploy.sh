
function logInfo(){
    echo "\033[36m$1 \033[0m: $2"
}

function console(){
    echo "\033[33m$@ \033[0m"
}
function print(){
    echo "\033[35m$@ \033[0m"
}

HOST_PATH=$(cd `dirname $0`;pwd)

source $HOST_PATH/application-template.sh
source $HOST_PATH/cluster-template.sh

nacos_path=$1
download_url=$2

config_nacos_port=$3
config_nacos_dbnum=$4
config_nacos_dburl=$5
config_nacos_dbuser=$6
config_nacos_dbpassword=$7
config_cluster_nacos=$8
config_nacos_bind_ip=$9

application_file=$nacos_path/conf/application.properties
cluster_file=$nacos_path/conf/cluster.conf
startup_file=$nacos_path/bin/startup.sh

if [ ! -d "$nacos_path" ]; then
    echo "create nacos_path: $nacos_path"
    mkdir $nacos_path
fi
#下载文件名
down_file_name="${download_url##*/}"
#下载 解压后文件夹名
down_file_dir="${down_file_name%%.*}"


logInfo "down_file" $down_file_dir

logInfo "nacos_file" $down_file_name

logInfo "cluster_nacos" $cluster_nacos

cd $nacos_path

if [ ! -f "$down_file_name" ];then
    wget $download_url
fi

compress_retry_time=3
compress_retry_now=0

function delete_compress_dir(){
    rm -rf $down_file_dir
    console "delete down file directory"
}


function handle_tar_error(){
    if [ $compress_retry_now -gt $compress_retry_time ];then
        exit
    fi

    compress_retry_now = $(expr $compress_retry_now + 1)
    rm -rf download_url
    wget $download_url
    compress_tar
}

function compress_tar(){
    tar -xvzf $down_file_name || handle_tar_error
}


function write_application_config(){
    application_content=$(applicationTemplate)

cat>$application_file<<EOF
    $application_content
EOF
}

function write_cluster_config(){
    cluster_content=$(clusterTemplate)
cat>$cluster_file<<EOF
    $cluster_content
EOF
}

#
解压包
#
compress_tar

##
# 复制文件至 nacos_path
##
cp -r $down_file_dir/* ./

logInfo "copy source" "completed"
##
# 删除解压包
##
delete_compress_dir
##
# 写入application 配置文件
##
write_application_config
console "write application.properties completed!"
##
# 写入 cluster 配置文件
##
write_cluster_config
console "write cluster.conf completed!"
##
# 写入 startup.sh
##
cat $HOST_PATH/startup-template.j2 | sed "s/{{nacos_bind_ip}}/$config_nacos_bind_ip/g" > $startup_file
console "write startup.sh completed!!"
print "end!!"