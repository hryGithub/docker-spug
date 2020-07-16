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

if [[ -z $(mysql -u$DB_USER -p$DB_PASSWORD -h$DB_HOST -P$DB_PORT $DB_NAME -e "show tables;" |grep "django_migrations") ]];then
    cd /data/spug_api
    python manage.py updatedb
    python manage.py useradd -u admin -p spug.dev -s -n "管理员"
fi

nginx
supervisord -c /etc/supervisord.conf