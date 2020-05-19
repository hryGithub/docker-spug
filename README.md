# quick start
    docker run -d -p 80:80 -e DB_HOST= -e DB_PORT= -e DB_NAME= -e DB_USER= -e DB_PASSWORD= -e REDIS_HOST= -e REDIS_PORT= hyr326/spug:latest

# docker-compose
    git clone https://github.com/hryGithub/docker-spug.git
    cd docker
    docker-compose up 

# build 
    git clone https://github.com/hryGithub/docker-spug.git
    cd docker
    docker-compose -f docker-compose-build.yml up 

