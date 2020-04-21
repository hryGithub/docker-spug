DEBUG = False
ALLOWED_HOSTS = ['127.0.0.1']

CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "redis://127.0.0.1:6379/1",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        }
    }
}

CHANNEL_LAYERS = {
    "default": {
        "BACKEND": "channels_redis.core.RedisChannelLayer",
        "CONFIG": {
            "hosts": [("127.0.0.1", 6379)],
        },
    },
}

DATABASES = {
    'default': {
        'ATOMIC_REQUESTS': True,
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'spug_db',             # 替换为自己的数据库名，请预先创建好编码为utf8mb4的数据库
        'USER': 'spug_user',        # 数据库用户名
        'PASSWORD': 'spug_password',  # 数据库密码
        'HOST': 'spug_host',        # 数据库地址
        'PORT': '3306',             # 数据库端口号
        'OPTIONS': {
            'charset': 'utf8mb4',
            'sql_mode': 'STRICT_TRANS_TABLES',
            #'unix_socket': '/opt/mysql/mysql.sock' # 如果是本机数据库,且不是默认安装的Mysql,需要指定Mysql的socket文件路径
        }
    }
}