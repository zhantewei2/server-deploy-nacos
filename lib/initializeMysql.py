#
# 保证单个py程序
# 
import sys
import subprocess
import logging
from subprocess import PIPE,STDOUT

logging.basicConfig(level=logging.DEBUG)

try:
  # 如果没有安装，尝试使用pip进行安装。
  # 如果pip不行，那就嗝屁了
  import pymysql
except ImportError:
  logging.info("pymysql not be installed, start install")
  p=subprocess.Popen(
    "pip install pymysql",
    shell=True,
    stdout=PIPE,
    stderr=PIPE
  )
  while p.poll()==None:
    s=p.stdout.readline()
    print(str(s,'utf8'))

import pymysql
import os
from os import path
import re
from urllib.parse import urlparse,urlsplit

HOST_PATH=path.dirname(path.dirname(path.abspath(__file__)))
##
# 获取nacos 配置 
##
CONFG_FILE=path.join(HOST_PATH,'conf','nacos.conf')
NACOS_CONFIG={}
with open(CONFG_FILE,'r') as f:
  for line in f.readlines():
    line=line.strip()
    if line.startswith('#') or not line:
      continue
    m=re.match(r'(.*?)\s?=\s?[\'\"]?([^\'\"]*)[\'\"]?',line)
    if m:
      NACOS_CONFIG[m.group(1)]=m.group(2)

##
# 获取nacos sql
##
nacos_path=NACOS_CONFIG.get('target_nacos_path')
nacos_conf_path=path.join(nacos_path,'conf')
nacos_conf_sqls=[i for i in os.listdir(nacos_conf_path) if i.endswith('.sql')]

if len(nacos_conf_sqls)<1:
  logging.error("not found sql files!")
  sys.exit()
logging.info("sql files: "+ ",".join(nacos_conf_sqls))
##
# 连接 mysql
##
def connection_mysql():
  db_parse=urlparse(NACOS_CONFIG.get("db_url0"))
  host_parse=urlparse(db_parse.path)
  host_url=host_parse.netloc
  host_url_sep=host_url.split(":")
  if len(host_url_sep)>1:
    host,port=host_url_sep
  else:
    host=host_url
    port=3306

  db=host_parse.path.replace("/","")
  logging.debug(f'mysql : {host} {db} {str(port)}')
  return pymysql.connect(
    host=host,
    user=NACOS_CONFIG.get("db_user"),
    password=NACOS_CONFIG.get("db_password"),
    db=db,
    port=int(port)
  )

conn=connection_mysql()

###
# 初始化数据库，没有commit ，sql文件中insert操作,不触发.
###
def create_nacos_talbe()
with conn.cursor() as cursor:
  for sql_file in nacos_conf_sqls:
    if sql_file.find('mysql')<0:continue
    with open(path.join(nacos_conf_path,sql_file),'r') as f:
      content=f.read()
      content=re.sub(r'(\/\*.*?\*\/|\#.*)','',content)
      sql_list=content.split(";")
      for i in sql_list:
        i=i.strip()
        if not i: continue
        try:
          cursor.execute(i)
        except Exception as e:
          logging.error("sql exception: %s"%str(e))


logging.info("The SQL statement has bean written")