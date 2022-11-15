import os

DEBUG = False
ALLOWED_HOSTS = ['127.0.0.1']

CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "redis://"+ os.getenv('REDIS_HOST') + ":" + os.getenv('REDIS_PORT') + "/"  + os.getenv('REDIS_CACHES'),
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        }
    }
}

CHANNEL_LAYERS = {
    "default": {
        "BACKEND": "channels_redis.core.RedisChannelLayer",
        "CONFIG": {
            "hosts": ["redis://"+ os.getenv('REDIS_HOST') + ":" + os.getenv('REDIS_PORT') + "/"  + os.getenv('REDIS_CHANNEL'],
        },
    },
}

DATABASES = {
    'default': {
        'ATOMIC_REQUESTS': True,
        'ENGINE': 'django.db.backends.mysql',
        'NAME': os.getenv('DB_NAME'),             # 替换为自己的数据库名，请预先创建好编码为utf8mb4的数据库
        'USER': os.getenv('DB_USER'),        # 数据库用户名
        'PASSWORD': os.getenv('DB_PASSWORD'),  # 数据库密码
        'HOST': os.getenv('DB_HOST'),        # 数据库地址
        'PORT': os.getenv('DB_PORT'),             # 数据库端口号
        'OPTIONS': {
            'charset': 'utf8mb4',
            'sql_mode': 'STRICT_TRANS_TABLES',
            #'unix_socket': '/opt/mysql/mysql.sock' # 如果是本机数据库,且不是默认安装的Mysql,需要指定Mysql的socket文件路径
        }
    }
}
