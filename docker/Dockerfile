
FROM python:3.6.10-alpine3.10
ARG nacos_port
ARG nacos_path
WORKDIR /home/nacos
COPY . .
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update \
    && apk add build-base \
    && apk add libffi-dev \
    && sh bin/nacos-deploy-local.sh \
# remove apk
    && apk del libffi-dev build-base

EXPOSE ${nacos_port}
VOLUME  ["${nacos_path}"]
# modify time zone
RUN apk add --no-cache -U tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && apk del tzdata \
# install jdk8
    && apk add --no-cache openjdk8 \
# remove python
    && rm -rf /usr/local/lib
ENV JAVA_HOME /usr/lib/jvm/default-jvm
ENTRYPOINT sh bin/nacos-start.sh