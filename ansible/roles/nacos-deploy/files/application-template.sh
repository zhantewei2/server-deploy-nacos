#!/usr/bin/env bash

function applicationTemplate(){
    echo "
# spring
server.contextPath=/nacos
server.servlet.contextPath=/nacos
server.port=$config_nacos_port
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
db.num=$config_nacos_dbnum
db.url.0=$config_nacos_dburl
db.user=$config_nacos_dbuser
db.password=$config_nacos_dbpassword
# nacos.cmdb.dumpTaskInterval=3600
# nacos.cmdb.eventTaskInterval=10
# nacos.cmdb.labelTaskInterval=300
# nacos.cmdb.loadDataAtStart=false
nacos.inetutils.ip-address=$config_nacos_bind_ip

# metrics for prometheus
#management.endpoints.web.exposure.include=*

# metrics for elastic search
management.metrics.export.elastic.enabled=false
#management.metrics.export.elastic.host=http://localhost:9200

# metrics for influx
management.metrics.export.influx.enabled=false
#management.metrics.export.influx.db=springboot
#management.metrics.export.influx.uri=http://localhost:8086
#management.metrics.export.influx.auto-create-db=true
#management.metrics.export.influx.consistency=one
#management.metrics.export.influx.compressed=true

server.tomcat.accesslog.enabled=true
server.tomcat.accesslog.pattern=%h %l %u %t "%r" %s %b %D %{User-Agent}i
# default current work dir
server.tomcat.basedir=

## spring security config
### turn off security
#spring.security.enabled=false
#management.security=false
#security.basic.enabled=false
#nacos.security.ignore.urls=/**

nacos.security.ignore.urls=/,/**/*.css,/**/*.js,/**/*.html,/**/*.map,/**/*.svg,/**/*.png,/**/*.ico,/console-fe/public/**,/v1/auth/login,/v1/console/health/**,/v1/cs/**,/v1/ns/**,/v1/cmdb/**,/actuator/**,/v1/console/server/**

# nacos.naming.distro.taskDispatchPeriod=200
# nacos.naming.distro.batchSyncKeyCount=1000
# nacos.naming.distro.syncRetryDelay=5000
# nacos.naming.data.warmup=true
# nacos.naming.expireInstance=true

nacos.istio.mcp.server.enabled=false
"
}