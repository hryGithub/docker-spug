FROM python:3.6.10-alpine3.12

RUN sed -i "s@dl-cdn.alpinelinux.org@mirrors.aliyun.com@g" /etc/apk/repositories
RUN apk update && apk add --no-cache tzdata nginx git supervisor mariadb-client curl\
    openldap-dev mariadb-dev openssl-dev musl-dev python3-dev libffi-dev gcc make bash

ENV VERSION=2.3.17
ENV TZ=Asia/Shanghai


RUN git clone https://github.com/openspug/spug.git --depth=1 /data/spug

# RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/  && pip install --no-cache-dir -r /data/spug/spug_api/requirements.txt \
#    && pip install --no-cache-dir gunicorn mysqlclient
RUN pip install --upgrade pip && pip install --no-cache-dir gunicorn mysqlclient cryptography==3.3 && pip install --no-cache-dir -r /data/spug/spug_api/requirements.txt 
RUN cd /var/www && wget https://github.com/openspug/spug/releases/download/v$VERSION/web_v$VERSION.tar.gz && tar xf web_v$VERSION.tar.gz && rm -rf web_v$VERSION.tar.gz

ADD spug.ini /etc/supervisor.d/spug.ini
ADD overrides.py /data/spug/spug_api/spug/overrides.py
ADD default.conf /etc/nginx/conf.d/default.conf
ADD docker-entrypoint.sh /docker-entrypoint.sh

ENV DB_HOST=127.0.0.1 \
    DB_PORT=3306 \
    DB_NAME=spug \
    DB_USER=spug \
    DB_PASSWORD=spug \
    REDIS_HOST=127.0.0.1 \
    REDIS_PORT=6379

EXPOSE 80 9001 9002

VOLUME ["/data", "/var/www/build"]

ENTRYPOINT ["sh", "/docker-entrypoint.sh"]

