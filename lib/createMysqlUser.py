from connectMysql import conn,NACOS_CONFIG
import subprocess
from subprocess import PIPE
import logging

try:
    import bcrypt

except ImportError:
   logging.info('install bcrypt')
   p=subprocess.Popen(
       "pip install --no-cache-dir bcrypt",
       shell=True,
   )
   p.communicate()
import bcrypt

def encodepassword(password):
    return bcrypt.hashpw(
        bytes(password,'utf8'),
        bcrypt.gensalt(rounds=10,prefix=b'2a')
    )


with conn.cursor() as cursor:
    try:
        r1=cursor.execute("""
            insert into users(username,password,enabled)
            values (%s,%s,%s)
        """,args=(
            NACOS_CONFIG.get("nacos_user"),
            encodepassword(NACOS_CONFIG.get("nacos_pass")),
            1
        ))
        r2=cursor.execute("""
            insert into roles(username,role)
            values (%s,%s)
        """,args=(
            NACOS_CONFIG.get("nacos_user"),
            "ROLE_ADMIN"
        ))
        conn.commit()
    except Exception as e:
        print(e)