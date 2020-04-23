FROM python:3.6.10-alpine3.11

RUN echo -e "http://mirrors.aliyun.com/alpine/v3.11/main\nhttp://mirrors.aliyun.com/alpine/v3.11/community" > /etc/apk/repositories
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz
    
RUN apk update && apk add --no-cache tzdata nginx git openldap-dev supervisor mysql-client mysql-dev bash openssl-dev \
    gcc musl-dev python3-dev libffi-dev openssl-dev make \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone \
    && mkdir /etc/supervisor.d

ENV VERSION=2.2.4
RUN git clone https://github.com/openspug/spug.git --depth=1 /spug && cd /spug && git pull

RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/  && pip install --upgrade pip && pip install --no-cache-dir -r /spug/spug_api/requirements.txt \
    && pip install --no-cache-dir gunicorn mysqlclient

#RUN cd /spug/spug_web/ && npm i --registry=https://registry.npm.taobao.org && npm run build \
#    && mv /spug/spug_web/build /var/www/

RUN cd /var/www && wget https://github.com/openspug/spug/releases/download/v$VERSION/spug_web_$VERSION.tar.gz && tar xf spug_web_$VERSION.tar.gz && rm -rf spug_web_$VERSION.tar.gz

ADD spug.ini /etc/supervisor.d/spug.ini
ADD overrides.py /spug/spug_api/spug/overrides.py
ADD default.conf /etc/nginx/conf.d/default.conf
ADD entrypoint.sh /entrypoint.sh

ENV DB_HOST=127.0.0.1 \
    DB_PORT=3306 \
    DB_NAME=spug \
    DB_USER=spug \
    DB_PASSWORD=spug \
    REDIS_HOST=127.0.0.1 \
    REDIS_PORT=6379

EXPOSE 80 9001 9002

ENTRYPOINT ["sh", "/entrypoint.sh"]