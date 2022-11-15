# quick start
    docker run -d -p 80:80 -e DB_HOST= -e DB_PORT= -e DB_NAME= -e DB_USER= -e DB_PASSWORD= -e REDIS_HOST= -e REDIS_PORT= hyr326/spug:latest

# docker-compose
    git clone https://github.com/hryGithub/docker-spug.git
    cd docker-spug
    docker-compose up -d

# build 
    git clone https://github.com/hryGithub/docker-spug.git
    cd docker
    docker-compose -f docker-compose-build.yml up -d

# 环境变量说明
==以下环境变量必须全部填写==
|环境变量|说明|
|---     |--- |
|DB_HOST |数据库地址|
|DB_PORT |数据库端口|
|DB_NAME |数据库名  |
|DB_USER |数据库用户|
|DB_PASSWORD |数据库密码|
|REDIS_HOST |Redis地址|
|REDIS_PORT |Redis端口|
|REDIS_CACHES |指定Redis所使用的数据库|
|REDIS_CHANNEL |同上|
