#!/bin/sh
# Copyright: (c) OpenSpug Organization. https://github.com/openspug/spug
# Copyright: (c) <spug.dev@gmail.com>
# Released under the MIT License.

set -e
# set timezone
cp /usr/share/zoneinfo/$TZ /etc/localtime && echo "$TZ" > /etc/timezone

# init nginx
if [ ! -d /run/nginx ]; then
    mkdir -p /run/nginx
    chown -R nginx.nginx /run/nginx
fi

# init spug
sed -i "s@redis://127.0.0.1:6379@redis://$REDIS_HOST:$REDIS_PORT@g" /spug/spug_api/spug/overrides.py
sed -i "s@('127.0.0.1', 6379)@('$REDIS_HOST', $REDIS_PORT)@g" /spug/spug_api/spug/overrides.py
sed -i "s@'NAME': 'spug_db'@'NAME': '$DB_NAME'@g" /spug/spug_api/spug/overrides.py
sed -i "s@'USER': 'spug_user'@'USER': '$DB_USER'@g" /spug/spug_api/spug/overrides.py
sed -i "s@'PASSWORD': 'spug_password'@'PASSWORD': '$DB_PASSWORD'@g" /spug/spug_api/spug/overrides.py
sed -i "s@'HOST': 'spug_host'@'HOST': '$DB_HOST'@g" /spug/spug_api/spug/overrides.py
sed -i "s@'PORT': '3306'@'PORT': '$DB_PORT'@g" /spug/spug_api/spug/overrides.py


if [[ -z $(mysql -u$DB_USER -p$DB_PASSWORD -h$DB_HOST -P$DB_PORT $DB_NAME -e "show tables;" |grep "django_migrations") ]];then
    cd /spug/spug_api
    python manage.py initdb
    python manage.py useradd -u admin -p spug.dev -s -n "管理员"
fi

nginx
supervisord -c /etc/supervisord.conf