# 环境判断
if [ -f /etc/issue ];then
  if [ `cat /etc/issue |grep Debian` ]; then
    pass
  elif [ `cat /etc/issue |grep Kernel` ]; then
    pass
fi