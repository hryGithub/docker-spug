FROM python:3.6.10-alpine3.11

RUN echo -e "http://mirrors.aliyun.com/alpine/v3.11/main\nhttp://mirrors.aliyun.com/alpine/v3.11/community" > /etc/apk/repositories
RUN apk update && apk add --no-cache tzdata nginx git supervisor mariadb-client \
    openldap-dev mariadb-dev openssl-dev musl-dev python3-dev libffi-dev gcc make bash

ENV VERSION=2.3.0
ENV TZ=Aisa/Shanghai

RUN git clone https://github.com/openspug/spug.git --depth=1 /spug && cd /spug && git pull

RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/  && pip install --no-cache-dir -r /spug/spug_api/requirements.txt \
    && pip install --no-cache-dir gunicorn mysqlclient

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

