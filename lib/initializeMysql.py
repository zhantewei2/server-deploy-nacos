import os
from os import path
import re
import logging
import sys
from connectMysql import NACOS_CONFIG,conn

##
# 获取nacos sql
##
nacos_path = NACOS_CONFIG.get('target_nacos_path')
nacos_conf_path = path.join(nacos_path, 'conf')
nacos_conf_sqls = [i for i in os.listdir(nacos_conf_path) if i.endswith('.sql')]

if len(nacos_conf_sqls) < 1:
    logging.error("not found sql files!")
    sys.exit()
logging.info("sql files: " + ",".join(nacos_conf_sqls))


###
# 初始化数据库，没有commit ，sql文件中insert操作,不触发.
###
def create_nacos_talbe():
    pass


with conn.cursor() as cursor:
    for sql_file in nacos_conf_sqls:
        if sql_file.find('mysql') < 0: continue
        with open(path.join(nacos_conf_path, sql_file), 'r') as f:
            content = f.read()
            content = re.sub(r'(\/\*.*?\*\/|\#.*)', '', content)
            sql_list = content.split(";")
            for i in sql_list:
                i = i.strip()
                if not i: continue
                try:
                    cursor.execute(i)
                except Exception as e:
                    logging.error("sql exception: %s" % str(e))

logging.info("The SQL statement has bean written")
