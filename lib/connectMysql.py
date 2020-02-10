import sys
import subprocess
from urllib.parse import urlparse
from os import path
import logging
import re
from subprocess import PIPE

##尝试 pymysql
#
##
try:
    import pymysql
except ImportError:
    logging.info("pymysql not be installed, start install")
    p = subprocess.Popen(
        "pip install --no-cache-dir pymysql",
        shell=True,
        stdout=PIPE,
        stderr=PIPE
    )
    while p.poll() == None:
        s = p.stdout.readline()
        print(str(s, 'utf8'))

import pymysql


HOST_PATH = path.dirname(path.dirname(path.abspath(__file__)))
##
# 获取nacos 配置
##
CONFG_FILE = path.join(HOST_PATH, 'conf', 'nacos.conf')
NACOS_CONFIG = {}
with open(CONFG_FILE, 'r') as f:
    for line in f.readlines():
        line = line.strip()
        if line.startswith('#') or not line:
            continue
        m = re.match(r'(.*?)\s?=\s?[\'\"]?([^\'\"]*)[\'\"]?', line)
        if m:
            NACOS_CONFIG[m.group(1)] = m.group(2)


def connection_mysql():
    db_parse = urlparse(NACOS_CONFIG.get("db_url0"))
    host_parse = urlparse(db_parse.path)
    host_url = host_parse.netloc
    host_url_sep = host_url.split(":")
    if len(host_url_sep) > 1:
        host, port = host_url_sep
    else:
        host = host_url
        port = 3306

    db = host_parse.path.replace("/", "")
    logging.debug(f'mysql : {host} {db} {str(port)}')
    return pymysql.connect(
        host=host,
        user=NACOS_CONFIG.get("db_user"),
        password=NACOS_CONFIG.get("db_password"),
        db=db,
        port=int(port)
    )

conn=connection_mysql()