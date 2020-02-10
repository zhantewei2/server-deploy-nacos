NACOS 部署
---
(mysql8修改版 nacos)

自动完成：
- nacos docker部署。
- 创建nacos sql table。
- 创建指定的 nacos 账号。

docker版
===
- 修改 conf/nacos.conf
- 构建镜像 `sh bin/build-docker.sh`
- 运行容器 `sh bin/run-docker.sh `

本地版
===
- 修改conf/nacos.conf
- 安装python3, pip, jdk8
- `sh nacos-deploy-local.sh`
- `sh nacos-start.sh`

ansible版
===
支持